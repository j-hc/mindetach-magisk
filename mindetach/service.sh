#!/system/bin/sh
# shellcheck disable=SC2086
MODDIR=${0%/*}

. $MODDIR/utils.sh
until [ "$(getprop sys.boot_completed)" = 1 ] && [ -d /sdcard/Android ]; do sleep 2; done
sleep 20

APPS=$(get_apps) && {
	am force-stop com.android.vending
	disable_au "$APPS"
	detach "$APPS"
}
