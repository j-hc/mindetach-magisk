# mindetach magisk module

Magisk module to detach apps from Play Store  

I use a more efficient method than other modules (basically registering a trigger in the DB) to persist the detachment which **does not run on the background** or have the overhead of any type of scheduling.

## Usage
Apps to detach are got either from `/sdcard/detach.txt` or `detach.txt` file inside the module.

`/sdcard/detach.txt` takes precedence.

`detach.txt` format:
```
com.google.android.youtube
com.someotherapp
```

Apps will be detached from Play Store once you flash the module. To re-attach them, remove the module and clean the data of Play Store.