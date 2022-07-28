#MINAPI=21
#MAXAPI=25
#DYNLIB=true
#DEBUG=true

set_permissions() {
  chmod +x $MODPATH/sqlite3
}

SKIPUNZIP=1
unzip -qjo "$ZIPFILE" 'common/functions.sh' -d $TMPDIR >&2
. $TMPDIR/functions.sh
