import 'dart:async';
import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:system_idle/src/system_idle.dart';
import 'package:win32/winrt.dart';

class SystemIdleCheckerWindows extends SystemIdleChecker {
  final _controller = StreamController<bool>.broadcast();

  bool _isIdle = false;
  @override
  Future<void> initialize({int time = defaultIdleTime}) async {
    final plii = calloc<LASTINPUTINFO>()..ref.cbSize = sizeOf<LASTINPUTINFO>();

    Timer.periodic(const Duration(seconds: 1), (timer) async {
      final ticks = getTickCountFunc();
      GetLastInputInfo(plii);

      final idleFor = (ticks - plii.ref.dwTime) / 1000;

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
final getTickCountFunc =
    kernel32.lookupFunction<Uint32 Function(), int Function()>("GetTickCount");
