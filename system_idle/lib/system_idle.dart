import "dart:io";

import "package:system_idle_linux/system_idle_linux.dart";
import "package:system_idle_macos/system_idle_macos.dart";
import "package:system_idle_platform_interface/system_idle_platform_interface.dart";
import "package:system_idle_windows/system_idle_windows.dart";

/// The system_idle plugin.
///
/// Use [forPlatform] to get the appropriate plugin for your platform. Then, be sure to call
/// [initialize] before doing anything else. This will set the value of [isSupported] properly,
/// which you can use to decide whether to rely on the plugin.
///
/// There are two main ways to use this plugin:
/// - [onIdleChanged] will return a stream whenever the user goes idle
/// - [getIdleDuration] will return how long the user has been idle for.
///   Not all platforms support this so it may return null.
abstract class SystemIdle extends SystemIdlePlatformInterface {
  /// Determines the correct plugin for the given platform and device.
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

/// Utils on the system_idle plugin.
extension SystemIdleUtils on SystemIdlePlatformInterface {
  /// Allows you to check if a specific platform implementation is being used.
  T? resolvePlatform<T extends SystemIdlePlatformInterface>() =>
    this is T ? this as T : null;
}
