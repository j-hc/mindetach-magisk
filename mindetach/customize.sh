# shellcheck disable=SC2148,SC2086,SC2115
if [ "$ARCH" = "arm" ]; then
  mv -f $MODPATH/sqlite3-arm $MODPATH/sqlite3
  mv -f $MODPATH/lib/libz-arm.so $MODPATH/lib/libz.so
elif [ "$ARCH" = "arm64" ]; then
  mv -f $MODPATH/sqlite3-arm64 $MODPATH/sqlite3
  mv -f $MODPATH/lib/libz-arm64.so $MODPATH/lib/libz.so
else
  abort "ERROR: unsupported arch: ${ARCH}"
fi

rm $MODPATH/sqlite3-* $MODPATH/lib/libz-*
chmod +x $MODPATH/sqlite3

ui_print "- Detaching..."
. $MODPATH/service.sh
