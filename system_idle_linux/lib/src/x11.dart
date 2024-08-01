
import "dart:ffi";

import "package:system_idle_platform_interface/system_idle_platform_interface.dart";

import "x11_bindings.dart";

class SystemIdleX11 extends SystemIdlePlatformInterface with SystemIdleTimer {
  final String _libraryPath;
  late final _library = DynamicLibrary.open(_libraryPath);
  late final _bindings = SystemIdleX11Bindings(_library);
  Pointer<X11Plugin> _plugin = nullptr;

  SystemIdleX11({String libraryPath = "libsystem_idle_linux_x11.so"}) :
    _libraryPath = libraryPath;

  @override
  bool isSupported = false;

  @override
  Future<void> initialize() async {
    _plugin = _bindings.createPlugin();
    isSupported = _bindings.initPlugin(_plugin);
  }

  @override
  Future<void> dispose() async {
    if (_plugin != nullptr) _bindings.freePlugin(_plugin);
    _plugin = nullptr;
    await super.dispose();
  }

  @override
  Future<Duration> getIdleDuration() async {
    if (_plugin == nullptr) throw StateError("You must call SystemIdleLinux.init() before getIdleDuration()");
    final ms = _bindings.getIdleTime(_plugin);
    return Duration(milliseconds: ms);
  }
}
