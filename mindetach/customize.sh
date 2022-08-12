# shellcheck disable=SC2148,SC2086
if [ "$ARCH" = "arm" ]; then
	mv -f $MODPATH/sqlite3-arm $MODPATH/sqlite3
elif [ "$ARCH" = "arm64" ]; then
	mv -f $MODPATH/sqlite3-arm64 $MODPATH/sqlite3
else
	abort "ERROR: unsupported arch: ${ARCH}"
fi

rm $MODPATH/sqlite3-*
chmod +x $MODPATH/sqlite3

MODDIR=$MODPATH
. $MODPATH/utils.sh

APPS=$(get_apps) && {
	ui_print "- Disabling Auto-Update.."
	am force-stop com.android.vending
	if ! op=$(disable_au "$APPS"); then
		ui_print "- WARNING: fail"
		ui_print "    $op"
	fi

	ui_print "- Detaching.."
	if ! op=$(detach "$APPS"); then
		ui_print "- WARNING: fail"
		ui_print "    $op"
	fi
}

ui_print "  by j-hc (github.com/j-hc)"
