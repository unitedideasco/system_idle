import "dart:io";

import "package:system_idle_linux/system_idle_linux.dart";
import "package:system_idle_macos/system_idle_macos.dart";
import "package:system_idle_platform_interface/system_idle_platform_interface.dart";
import "package:system_idle_windows/system_idle_windows.dart";

abstract class SystemIdle extends SystemIdlePlatformInterface {
  static SystemIdlePlatformInterface forPlatform() {
    if (Platform.isLinux) {
      return SystemIdleLinux.forWindowManager();
    } else if (Platform.isMacOS) {
      return SystemIdleMacOS();
    } else if (Platform.isWindows) {
      return SystemIdleWindows();
    } else {
      return SystemIdleStub();
    }
  }
}

extension SystemIdleUtils on SystemIdlePlatformInterface {
  T? resolvePlatform<T extends SystemIdlePlatformInterface>() =>
    this is T ? this as T : null;
}
