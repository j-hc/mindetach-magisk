#![no_main]
#![feature(iter_intersperse)]

use libc_print::libc_println;
use std::path::Path;

macro_rules! db_dir {
    () => {
        "/data/data/com.android.vending/databases/"
    };
}

macro_rules! query {
    ($arg:literal) => {
        (
            concat!(db_dir!(), $arg, ".db"),
            include_bytes!(concat!("sql/", $arg, ".sql")),
        )
    };
}

macro_rules! f {
    ($($s:expr),*) => {
        [ $( AsRef::<str>::as_ref(&$s) ),* ].concat()
    };
}

static mut QUERY: [(&str, &[u8]); 6] = [
    query!("auto_update"),
    query!("frosting"),
    query!("install_queue"),
    query!("install_source"),
    query!("library"),
    query!("localappstate"),
];

fn get_apps() -> Option<Vec<String>> {
    let exe = std::env::current_exe().unwrap();
    let modpath = exe.ancestors().skip(3).next().unwrap();
    let detach_txt = modpath.join("detach.txt");

    for detach_path in [
        Path::new("/sdcard/detach.txt"),
        Path::new("/data/adb/modules/mindetach/detach.txt"),
        &detach_txt,
    ]
    .iter()
    .filter(|p| p.exists())
    {
        let apps = std::fs::read_to_string(detach_path)
            .ok()?
            .lines()
            .map(|s| s.trim())
            .filter(|l| !l.is_empty() && !l.starts_with('#'))
            .map(|s| f!("'", s, "'"))
            .collect::<Vec<_>>();
        if !apps.is_empty() {
            return Some(apps);
        }
    }
    None
}

#[no_mangle]
pub extern "C" fn main(_argc: i32, _argv: *const *const u8) -> i32 {
    run()
}

fn alt_name(s: &str) -> String {
    let s = s
        .as_bytes()
        .iter()
        .cloned()
        .intersperse(b'%')
        .collect::<Vec<_>>();
    unsafe { String::from_utf8_unchecked(s) }
}

fn db_open(path: &str) -> sqlite::Result<sqlite::Connection> {
    let f = sqlite::OpenFlags::new().set_read_write().set_no_mutex();
    let mut conn = sqlite::Connection::open_with_flags(path, f)?;
    conn.set_busy_timeout(2000)?;
    Ok(conn)
}

fn apply_verify_apps(apps: &[String]) -> bool {
    if let Ok(conn) = db_open(concat!(db_dir!(), "verify_apps.db")) {
        for n in apps.iter() {
            let sql = f!("DELETE FROM apk_info WHERE data LIKE ", &alt_name(n));
            match conn.execute(&sql) {
                Ok(_) => return true,
                Err(e) => {
                    if cfg!(feature = "print_stdout") {
                        libc_println!("ERROR: {}", e);
                    }
                }
            }
        }
    }
    false
}

fn run() -> i32 {
    let Some(apps) = get_apps() else {
        libc_println!("- All detach.txt files were empty. Skipping detaching.");
        return 0;
    };
    let apps_concat = apps.join(",");
    libc_println!("- Apps: {}", apps_concat);

    for (i, (p, q)) in unsafe { QUERY.iter_mut() }.enumerate() {
        let sql = unsafe { std::str::from_utf8_unchecked(q) }.replace("PKGNAME", &apps_concat);
        match db_open(p) {
            Ok(conn) => match conn.execute(&sql) {
                Ok(_) => libc_println!("- STEP {}: OK", i + 1),
                Err(err) => {
                    libc_println!("- STEP {}: SKIPPED (query: {})", i + 1, err)
                }
            },
            Err(_) => libc_println!("- STEP {}: SKIPPED", i + 1),
        };
    }

    let i = unsafe { QUERY.len() } + 1;
    if apply_verify_apps(&apps) {
        libc_println!("- STEP {}: OK", i)
    } else {
        libc_println!("- STEP {}: SKIPPED", i)
    }

    0
}
