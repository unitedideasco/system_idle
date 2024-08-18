import 'dart:async';

import 'package:flutter/services.dart';

import "interface.dart";

class SystemIdleCheckerMacOS extends SystemIdleChecker {
  final _controller = StreamController<bool>.broadcast();

  static const _channel = MethodChannel('unitedideas.co/system_idle');

  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    _controller.close();
  }

  @override
  Future<void> initialize({required Duration duration}) async {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
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
  Future<Duration> getIdleDuration() async {
    final seconds = await _channel.invokeMethod("getIdleTime");
    return Duration(seconds: seconds);
  }

  @override
  Stream<bool> onIdleStateChanged() => _controller.stream;
}
