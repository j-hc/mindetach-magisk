#!/system/bin/sh
# shellcheck disable=SC2086
MODDIR=${0%/*}
until [ "$(getprop sys.boot_completed)" = 1 ]; do sleep 1; done
until [ -d /sdcard/Android ]; do sleep 1; done
sleep 15

am force-stop com.android.vending
$MODDIR/system/bin/mindetach
am force-stop com.android.vending
