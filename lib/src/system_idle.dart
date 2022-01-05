import 'dart:async';

import 'package:flutter/services.dart';

const couldNotInitialize = 'Could not initialize the plugin';
const notInitialized = 'Plugin has not been initialized. Call initialize first';
const systemReturnedNull = 'System returned null value';
const unknownError = 'Unknown error';

class SystemIdleException implements Exception {
  const SystemIdleException({required this.message});

  final String message;
}

class SystemIdle {
  static const MethodChannel _channel =
      MethodChannel('unitedideas.co/system_idle');

  var _isInitialized = false;
  late int _idleTime;

  /// Initializes the system_idle plugin by passing idleTime in seconds.
  ///
  /// Default time is 5 minutes.
  Future<void> initialize({int time = 300}) async {
    _idleTime = time;
    _isInitialized = true;
  }

  /// Returns whether system is in idle state after given amout of time in milliseconds
  ///
  /// Throws a [SystemIdleException] if an error occurs.
  Future<bool> isIdle() async {
    try {
      if (!_isInitialized) {
        throw const SystemIdleException(message: notInitialized);
      }

      final isIdle = await _channel.invokeMethod<bool>(
        'isIdle',
        <String, Object>{
          'idleTime': _idleTime,
        },
      );

      if (isIdle == null) {
        throw const SystemIdleException(message: 'System returned null value');
      }

      return isIdle;
    } catch (_) {
      throw const SystemIdleException(message: unknownError);
    }
  }
}
