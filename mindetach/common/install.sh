case $ARCH in
arm)
	mv -f $MODPATH/sqlite3_arm $MODPATH/sqlite3
	;;
arm64)
	mv -f $MODPATH/sqlite3_arm64 $MODPATH/sqlite3
	;;
x86)
	mv -f $MODPATH/sqlite3_x86 $MODPATH/sqlite3
	;;
x64)
	mv -f $MODPATH/sqlite3_x64 $MODPATH/sqlite3
	;;
esac

rm $MODPATH/sqlite3_*
