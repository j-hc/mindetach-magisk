# mindetach magisk module

Magisk module to detach apps from Play Store  
I use a different method from other modules (basically registering a trigger in the db) to persist the detachment which does not have the overhead of tasker or some other type of scheduling.

sqlite3 binaries are compiled from source.  
TODO to myself: compile those binaries on gh actions

## Usage
Apps to detach are got either from `/sdcard/detach.txt` or `detach.txt` file inside the module

`/sdcard/detach.txt` takes precedence

`detach.txt` format:
```
com.google.android.youtube
com.someotherapp
```

After reboot, apps will be detached from Play Store