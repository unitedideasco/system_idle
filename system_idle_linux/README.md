# system_idle_linux

The Linux implementation of [`system_idle`](https://pub.dev/packages/system_idle). Since this
package uses FFI, it can be used in any Windows device with or without Flutter. If you are using
Flutter, simply import `package:system_idle` and this package will be included for you.

### Usage

First, initialize the plugin:
```dart
// Flutter apps:
import "package:system_idle/system_idle.dart";
// Non-Flutter apps:
import "package:system_idle_linux/system_idle_linux.dart";

// Flutter apps:
final plugin = SystemIdle();
// Non-Flutter apps:
final plugin = SystemIdleLinux();

await plugin.init();
```

Then you can check how long the user has been idle for:
```dart
final duration = await plugin.getIdleDuration();
print("The user has been idle for ${duration.inSeconds} seconds");
```

Or request a stream for one-off events:
```dart
plugin.onIdleChanged(idleDuration: Duration(seconds: 5)).listen(_onIdleChanged);

void _onIdleChanged(bool isIdle) => isIdle
  ? print("The user has been idle for at least 5 seconds")
  : print("The user is no longer idle!");
```

When you are done, be sure to call `dispose`, after which any streams obtained
by `onIdleChanged` will stop emitting events.

## Compiling

Flutter apps will automatically compile the native code for this plugin.

You'll need to have `libxcb` installed, including the screensaver extensions.

To build, simply install [`libxcb`](https://xcb.freedesktop.org) and run the Makefile:
```bash
sudo apt install libxcb1-dev libxcb-screensaver0-dev
make -C src
```

The dynamic libraries will be in `dist/`. Make sure these files are on your
PATH or your current directory when you run your code.
