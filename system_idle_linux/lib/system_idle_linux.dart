import "dart:ffi";

import "package:system_idle_platform_interface/system_idle_platform_interface.dart";

import "src/bindings.dart";

class SystemIdleLinux extends SystemIdlePlatformInterface with SystemIdleTimer {
  static late final _library = DynamicLibrary.open("system_idle_linux.so");
  static late final _bindings = SystemIdleBindings(_library);
  Pointer<NativePlugin> _plugin = nullptr;

  @override
  Future<void> initialize() async {
    _plugin = _bindings.createPlugin();
    _bindings.initPlugin(_plugin);
  }

  @override
  Future<void> dispose() async {
    if (_plugin != nullptr) _bindings.freePlugin(_plugin);
    await super.dispose();
  }

  @override
  Future<Duration> getIdleDuration() async {
    if (_plugin == nullptr) throw StateError("You must call SystemIdleLinux.init() before getIdleDuration()");
    final ms = _bindings.getIdleTime(_plugin);
    return Duration(milliseconds: ms);
  }
}
