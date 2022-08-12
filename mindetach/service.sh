#!/system/bin/sh
# shellcheck disable=SC2086
until [ "$(getprop sys.boot_completed)" = 1 ]; do sleep 2; done
sleep 20

MODDIR=${0%/*}

. $MODDIR/utils.sh

APPS=$(get_apps) && {
	am force-stop com.android.vending
	disable_au "$APPS"
	detach "$APPS"
}
