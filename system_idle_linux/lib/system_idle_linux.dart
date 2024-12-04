import "dart:io";

import "package:system_idle_platform_interface/system_idle_platform_interface.dart";

import "src/x11.dart";
import "src/wayland.dart";

const _pluginConstructors = <String, SystemIdlePlatformInterface Function()>{
  "x11": SystemIdleX11.new,
  "wayland": SystemIdleWayland.new,
};

/// An implementation of the system_idle plugin for Linux (Wayland and X11).
abstract class SystemIdleLinux extends SystemIdlePlatformInterface {
  /// Determines which Window manager to work with. Only Wayland and X11 are supported.
  static SystemIdlePlatformInterface forWindowManager() {
    final windowManager = Platform.environment["XDG_SESSION_TYPE"];
    final constructor = _pluginConstructors[windowManager] ?? SystemIdleStub.new;
    return constructor();
  }
}
