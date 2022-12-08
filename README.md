<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->

# System idle
## A simple package for checking if computer was idle for given amount of time.
<br>

| Platform | Status      | 
|----------|-------------|
| Windows  | ✅ Working | 
| Linux    | ✅ Working |  
| macOS    | ✅ Working | 
<br>
## How to use it

### Initialize with desired time, after which computer is considered idle.
```dart
await SystemIdle.instance.initialize(time: 10);
```
In given example idle time is set to 10 seconds. If no mouse/keyboard input were detected after this time idle state will be emited.
<br><br>
### Listening to idle state changes
```dart
SystemIdle.instance.onIdleStateChanged.listen(
    (isIdle) => setState(() => _isIdle = isIdle),
);
```