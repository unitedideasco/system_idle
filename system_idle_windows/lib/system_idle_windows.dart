import "dart:ffi";

import "package:system_idle_platform_interface/system_idle_platform_interface.dart";

import "package:ffi/ffi.dart";
import "package:win32/win32.dart" as win32;

class SystemIdleWindows extends SystemIdlePlatformInterface with SystemIdleTimer {
  final _arena = Arena();
  late final _inputInfo = _arena<win32.LASTINPUTINFO>();

  @override
  Future<void> initialize() async {
    _inputInfo.ref.cbSize = sizeOf<win32.LASTINPUTINFO>();
  }

  @override
  Future<Duration> getIdleDuration() async {
    final currentTick = win32.GetTickCount();
    win32.GetLastInputInfo(_inputInfo);
    final lastInputTick = _inputInfo.ref.dwTime;
    final idleFor = currentTick - lastInputTick;;
    return Duration(milliseconds: idleFor);
  }
}
