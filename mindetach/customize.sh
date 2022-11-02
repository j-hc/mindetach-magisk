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

succes=true
APPS=$(get_apps) && {
	ui_print "- Disabling Auto-Update.."
	am force-stop com.android.vending
	if ! op=$(disable_au "$APPS"); then
		succes=false
		ui_print "- WARNING:"
		ui_print "    $op"
		ui_print ""
	fi

	ui_print "- Detaching.."
	if ! op=$(detach "$APPS"); then
		succes=false
		ui_print "- WARNING:"
		ui_print "    $op"
		ui_print ""
	fi

	ui_print "- Clearing install queue.."
	if ! op=$(clear_iq "$APPS"); then
		"- No queue was cleared"
	fi
}

if [ $succes = false ]; then
	if [ -d /data/data/com.android.vending ]; then
		ui_print "- Do not clean the data of Play Store"
		ui_print "- Open Play Store and reflash mindetach again!"
	else
		ui_print "- Immediate detach was not successful"
		ui_print "- This may be because you are not using Magisk Manager"
		ui_print "- mindetach will only work after a reboot!"
	fi
fi

ui_print ""
ui_print "  by j-hc (github.com/j-hc)"
