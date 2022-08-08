#!/system/bin/sh
# shellcheck disable=SC2086
if [ "$(getprop sys.boot_completed)" != 1 ]; then
	until [ "$(getprop sys.boot_completed)" = 1 ]; do sleep 2; done
	sleep 13
fi
MODDIR=${MODPATH:-${0%/*}}

detach() {
	DET_APPS=$(cat /sdcard/detach.txt || cat $MODDIR/detach.txt)
	[ -z "$DET_APPS" ] && return
	DETACH=$(echo "$DET_APPS" | tr -d ' ' | grep -v '^$' | sed "s/.*/'&'/" | paste -sd "," -) # -> 'com.app1','com.app2'
	[ -z "$DETACH" ] && return

	SQL="DROP TRIGGER IF EXISTS mindetach;
UPDATE ownership SET library_id='u-wl' WHERE doc_id IN (${DETACH});
CREATE TRIGGER mindetach
	BEFORE INSERT ON ownership
	WHEN NEW.doc_id in (${DETACH})
BEGIN
	SELECT RAISE(FAIL, 'mindetach');
END"
	am force-stop com.android.vending
	LD_LIBRARY_PATH=$MODDIR/lib $MODDIR/sqlite3 /data/data/com.android.vending/databases/library.db "$SQL"
}

detach
