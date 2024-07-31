import "dart:async";

import "package:flutter/services.dart";
import "package:system_idle_platform_interface/system_idle_platform_interface.dart";

class SystemIdleMacOS extends SystemIdlePlatformInterface with SystemIdleTimer {
  static const _channel = MethodChannel("unitedideas.co/system_idle");

  @override
  Future<void> initialize() async { }

  @override
  Future<Duration> getIdleDuration() async {
    final seconds = await _channel.invokeMethod<int>("getIdleTime");
    return Duration(seconds: seconds!);
  }
}
