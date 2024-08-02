## 2.0.0
* Changed this package to be a federated plugin
* Fixed Linux implementation by using FFI
* **Breaking** Instead of passing a `Duration` to `initialize`, you now pass it to `onIdleChanged`, and get a stream that uses that duration.

## 1.1.0
* Added `Future<Duration> getIdleDuration()`
* Made `initialize` idempotent so you can call it again with a different duration

## 1.0.0
* Change `initialize` to take a `Duration` instead of integer seconds

## 0.2.1
* Bump win32 version to 3.1.3

## 0.2.0

* Cleaned up of the code
* Changed ffi version to 1.0.0

## 0.1.1

* Changed win32 version to 2.6.1

## 0.1.0

* Refactor & split code better between platforms

## 0.0.1

* Initial working version of the package
