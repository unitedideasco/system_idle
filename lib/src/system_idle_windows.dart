import 'dart:async';
import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:system_idle/src/system_idle.dart';
import 'package:win32/win32.dart' as win32;

class SystemIdleCheckerWindows extends SystemIdleChecker {
  final _controller = StreamController<bool>.broadcast();
  final _arena = Arena();
  bool _isIdle = false;

  @override
  Future<void> initialize({int time = defaultIdleTime}) async {
    final inputInfo = _arena<win32.LASTINPUTINFO>();
    inputInfo.ref.cbSize = sizeOf<win32.LASTINPUTINFO>();

    Timer.periodic(const Duration(seconds: 1), (timer) async {
      final ticks = getTickCountFunc();
      win32.GetLastInputInfo(inputInfo);

      final idleFor = (ticks - inputInfo.ref.dwTime) / 1000;

      if (idleFor > time) {
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
