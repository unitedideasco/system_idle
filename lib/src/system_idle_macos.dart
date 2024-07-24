import 'dart:async';

import 'package:flutter/services.dart';
import 'package:system_idle/src/system_idle.dart';

class SystemIdleCheckerMacOS extends SystemIdleChecker {
  final _controller = StreamController<bool>.broadcast();

  static const _channel = MethodChannel('unitedideas.co/system_idle');

  @override
  Future<void> initialize({required Duration duration}) async {
    Timer.periodic(const Duration(seconds: 1), (timer) async {
      final isIdle = await _channel.invokeMethod<bool>(
        'isIdle',
        <String, Object>{'idleTime': duration.inSeconds},
      );

      if (isIdle == null) {
        throw const SystemIdleException(message: 'System returned null value');
      }

      _controller.sink.add(isIdle);
    });
  }

  @override
  Stream<bool> onIdleStateChanged() => _controller.stream;
}
