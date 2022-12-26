#!/system/bin/sh
# shellcheck disable=SC2086
DBS=/data/data/com.android.vending/databases

get_apps() {
	det_apps=$(cat /sdcard/detach.txt || cat $MODDIR/detach.txt)
	[ -z "$det_apps" ] && return 1
	DETACH=$(echo "$det_apps" | tr -d ' \t\r' | grep -v '^$' | sed "s/.*/'&'/" | paste -sd "," -)
	[ -z "$DETACH" ] && return 1
	echo "$DETACH"
}

disable_au() {
	SQL="UPDATE appstate SET auto_update = 2 WHERE package_name IN (${1})"
	$MODDIR/sqlite3 $DBS/localappstate.db "$SQL" 2>&1
}

detach() {
	SQL="DROP TRIGGER IF EXISTS mindetach;
UPDATE ownership SET doc_type = '25' WHERE doc_id IN (${1});
CREATE TRIGGER mindetach
	BEFORE INSERT ON ownership
	WHEN NEW.doc_id in (${1})
BEGIN
	SELECT RAISE(FAIL, 'mindetach');
END"
	$MODDIR/sqlite3 $DBS/library.db "$SQL" 2>&1
}

reattach() {
	SQL="DROP TRIGGER IF EXISTS mindetach;
UPDATE ownership SET doc_type = '1' WHERE doc_id IN (${1});"
	$MODDIR/sqlite3 $DBS/library.db "$SQL" 2>&1
}
clear_iq() {
	SQL="DELETE FROM install_requests WHERE pk IN (${1})"
	$MODDIR/sqlite3 $DBS/install_queue.db "$SQL" 2>&1
}
