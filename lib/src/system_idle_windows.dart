import 'dart:async';
import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:win32/win32.dart' as win32;

import "interface.dart";

class SystemIdleCheckerWindows extends SystemIdleChecker {
  final _controller = StreamController<bool>.broadcast();
  final _arena = Arena();
  late final _inputInfo = _arena<win32.LASTINPUTINFO>();

  bool _isIdle = false;

  @override
  Future<Duration> getIdleDuration() async {
    final ticks = getTickCountFunc();
    win32.GetLastInputInfo(_inputInfo);
    final idleFor = ticks - _inputInfo.ref.dwTime;
    return Duration(milliseconds: idleFor);
  }

  @override
  Future<void> initialize({required Duration duration}) async {
    _inputInfo.ref.cbSize = sizeOf<win32.LASTINPUTINFO>();

    Timer.periodic(const Duration(seconds: 1), (timer) async {
      final ticks = getTickCountFunc();
      win32.GetLastInputInfo(_inputInfo);

      final idleFor = (ticks - _inputInfo.ref.dwTime);

      if (idleFor > duration.inMilliseconds) {
        if (_isIdle) return;
        _isIdle = true;
        _controller.sink.add(true);
      } else {
        if (!_isIdle) return;
        _isIdle = false;
        _controller.sink.add(false);
      }
    });
  }

  @override
  Stream<bool> onIdleStateChanged() => _controller.stream;
}

final DynamicLibrary kernel32 = DynamicLibrary.open("kernel32.dll");
final getTickCountFunc = kernel32.lookupFunction<Uint32 Function(), int Function()>("GetTickCount");
