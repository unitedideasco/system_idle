# system_idle_windows

The Windows implementation of [`system_idle`](https://pub.dev/packages/system_idle). Since this
package uses FFI, it can be used in any Windows device with or without Flutter. If you are using
Flutter, simply import `package:system_idle` and this package will be included for you.

### Usage

First, initialize the plugin:
```dart
// Flutter apps:
import "package:system_idle/system_idle.dart";
// Non-Flutter apps:
import "package:system_idle_windows/system_idle_windows.dart";

// Flutter apps:
final plugin = SystemIdle();
// Non-Flutter apps:
final plugin = SystemIdleWindows();

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
