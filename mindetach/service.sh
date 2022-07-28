while [ "$(getprop sys.boot_completed)" != 1 ]; do sleep 2; done
sleep 13

DET_APPS=$(cat /sdcard/detach.txt || cat $MODDIR/detach.txt)

[ -z "$DET_APPS" ] && exit
DETACH=$(echo "$DET_APPS" | tr -d ' ' | grep -v '^$' | sed "s/.*/'&'/" | paste -sd "," -) # -> 'com.app1','com.app2'
[ -z "$DETACH" ] && exit

SQL="DROP TRIGGER IF EXISTS mindetach;
UPDATE ownership SET library_id='u-wl' WHERE doc_id IN (${DETACH});
CREATE TRIGGER mindetach
	BEFORE INSERT ON ownership
	WHEN NEW.doc_id in (${DETACH})
BEGIN
	SELECT RAISE(FAIL, 'mindetach');
END"

am force-stop com.android.vending
$MODDIR/sqlite3 /data/data/com.android.vending/databases/library.db "$SQL"
