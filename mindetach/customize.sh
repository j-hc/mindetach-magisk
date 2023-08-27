# shellcheck disable=SC2148,SC2086

if [ ! -d /data/data/com.android.vending/databases ]; then
	ui_print "- Do not clean the data of Play Store"
	ui_print "- Open Play Store and reflash mindetach again!"
	abort ""
fi

mv -f $MODPATH/system/bin/mindetach-${ARCH} $MODPATH/system/bin/mindetach
rm $MODPATH/system/bin/mindetach-*

# preserve detach.txt
cp -f $NVBASE/modules/mindetach/detach.txt $MODPATH/detach.txt

am force-stop com.android.vending
OP=$($MODPATH/system/bin/mindetach)
C=$?
am force-stop com.android.vending
ui_print "$OP"

if [ $C = 1 ]; then
	ui_print "- Immediate detach was not successful"
	ui_print "- This may be because you are not using Magisk Manager"
	ui_print "- mindetach will only work after a reboot!"
fi
ui_print ""
ui_print "  by j-hc (github.com/j-hc)"
