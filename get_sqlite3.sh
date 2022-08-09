#!/bin/bash

set -eu

req() { wget -nv --show-progress -O "$2" --header="User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101 Firefox/102.0" "$1"; }
req "https://github.com/j-hc/sqlite3-android/releases/download/20220809/sqlite3-arm" "./mindetach/sqlite3-arm"
req "https://github.com/j-hc/sqlite3-android/releases/download/20220809/sqlite3-arm64" "./mindetach/sqlite3-arm64"
