#!/system/bin/sh
# shellcheck disable=SC2086
MODDIR=/data/local/tmp
OLDMODDIR=${0%/*}
cp -f $OLDMODDIR/detach.txt $MODDIR
cp -f $OLDMODDIR/sqlite3 $MODDIR
. $OLDMODDIR/utils.sh
{
	until [ "$(getprop sys.boot_completed)" = 1 ] && [ -d /sdcard/Android ]; do sleep 2; done
	sleep 20
	APPS=$(get_apps) && {
		am force-stop com.android.vending
		reattach "$APPS"
	}
	rm $OLDMODDIR/detach.txt $OLDMODDIR/sqlite3
} &
