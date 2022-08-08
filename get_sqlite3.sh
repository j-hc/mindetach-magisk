#!/bin/bash

set -eu

req() { wget -nv --show-progress -O "$2" --header="User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101 Firefox/102.0" "$1"; }
mkdir -p mindetach/lib

req "https://github.com/Zackptg5/Cross-Compiled-Binaries-Android/blob/master/sqlite3/dynamic/lib-arm.zip?raw=true" "./libz-arm.zip"
unzip -pj libz-arm.zip "lib/libz.so" >mindetach/lib/libz-arm.so
strip mindetach/lib/libz-arm.so
req "https://github.com/Zackptg5/Cross-Compiled-Binaries-Android/blob/master/sqlite3/dynamic/sqlite3-arm?raw=true" "./mindetach/sqlite3-arm"

req "https://github.com/Zackptg5/Cross-Compiled-Binaries-Android/blob/master/sqlite3/dynamic/lib-arm64.zip?raw=true" "./libz-arm64.zip"
unzip -pj libz-arm64.zip "lib/libz.so" >mindetach/lib/libz-arm64.so
strip mindetach/lib/libz-arm64.so
req "https://github.com/Zackptg5/Cross-Compiled-Binaries-Android/blob/master/sqlite3/dynamic/sqlite3-arm64?raw=true" "./mindetach/sqlite3-arm64"

rm libz-arm64.zip libz-arm.zip
