# shellcheck disable=SC2148,SC2086

mv -f $MODPATH/sqlite3-${ARCH} $MODPATH/sqlite3
mv -f $MODPATH/detacher-${ARCH} $MODPATH/detacher
rm $MODPATH/sqlite3-* $MODPATH/detacher-*
chmod +x $MODPATH/detacher $MODPATH/sqlite3

am force-stop com.android.vending
OP=$($MODPATH/detacher 2>&1)
C=$?
ui_print "$OP"

if [ $C = 1 ]; then
	if [ -d /data/data/com.android.vending ]; then
		ui_print "- Do not clean the data of Play Store"
		ui_print "- Open Play Store and reflash mindetach again!"
		abort ""
	else
		ui_print "- Immediate detach was not successful"
		ui_print "- This may be because you are not using Magisk Manager"
		ui_print "- mindetach will only work after a reboot!"
	fi
fi
ui_print ""
ui_print "  by j-hc (github.com/j-hc)"
