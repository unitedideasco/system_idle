import "dart:io";

import "package:system_idle_platform_interface/system_idle_platform_interface.dart";

import "src/x11.dart";
import "src/wayland.dart";

const _pluginConstructors = <String, SystemIdlePlatformInterface Function()>{
  "x11": SystemIdleX11.new,
  "wayland": SystemIdleWayland.new,
};

abstract class SystemIdleLinux extends SystemIdlePlatformInterface {
  static SystemIdlePlatformInterface forWindowManager() {
    final windowManager = Platform.environment["XDG_SESSION_TYPE"];
    final constructor = _pluginConstructors[windowManager] ?? SystemIdleStub.new;
    return constructor();
  }
}
