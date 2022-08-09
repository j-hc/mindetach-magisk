# shellcheck disable=SC2148,SC2086,SC2115
if [ "$ARCH" = "arm" ]; then
  mv -f $MODPATH/sqlite3-arm $MODPATH/sqlite3
elif [ "$ARCH" = "arm64" ]; then
  mv -f $MODPATH/sqlite3-arm64 $MODPATH/sqlite3
else
  abort "ERROR: unsupported arch: ${ARCH}"
fi

rm $MODPATH/sqlite3-*
chmod +x $MODPATH/sqlite3

ui_print "- Detaching..."
. $MODPATH/service.sh
