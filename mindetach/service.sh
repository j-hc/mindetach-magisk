#!/system/bin/sh
# shellcheck disable=SC2086
MODDIR=${0%/*}

. $MODDIR/utils.sh
until [ "$(getprop sys.boot_completed)" = 1 ]; do sleep 1; done
until [ -d /sdcard/Android ]; do sleep 1; done
sleep 20

APPS=$(get_apps) && {
	am force-stop com.android.vending
	disable_au "$APPS"
	detach "$APPS"
}
