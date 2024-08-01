import "dart:io";

import "package:system_idle_linux/system_idle_linux.dart";
import "package:system_idle_macos/system_idle_macos.dart";
import "package:system_idle_platform_interface/system_idle_platform_interface.dart";
import "package:system_idle_windows/system_idle_windows.dart";

class SystemIdle extends SystemIdlePlatformInterface {
  factory SystemIdle() {
    if (Platform.isLinux) {
      return SystemIdle._(SystemIdleLinux.forWindowManager());
    } else if (Platform.isMacOS) {
      return SystemIdle._(SystemIdleMacOS());
    } else if (Platform.isWindows) {
      return SystemIdle._(SystemIdleWindows());
    } else {
      throw UnsupportedError("Unsupported platform: ${Platform.operatingSystem}");
    }
  }

  SystemIdlePlatformInterface _instance;
  SystemIdle._(this._instance);

  @override
  bool get isSupported => _instance.isSupported;

  @override
  Future<void> initialize() => _instance.initialize();

  @override
  Future<Duration?> getIdleDuration() => _instance.getIdleDuration();

  @override
  Future<void> dispose() async {
    _instance.dispose();
    await super.dispose();
  }

  @override
  Stream<bool> onIdleChanged({required Duration idleDuration}) => _instance.onIdleChanged(idleDuration: idleDuration);
}

extension SystemIdleUtils on SystemIdlePlatformInterface {
  T? resolvePlatform<T extends SystemIdlePlatformInterface>() =>
    this is T ? this as T : null;
}
