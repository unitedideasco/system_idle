import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;

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

    if (Platform.isLinux) {
      try {
        Process.run('killall', ['-9', 'idle']);
      } catch (_) {
        log('could not kill remaining idle processes');
      }

      try {
        final execFile = File(Platform.resolvedExecutable);
        final scriptFile = File(p.join(execFile.parent.path, 'idle'));

        final idleScript = _generateIdleScript(time);
        await scriptFile.writeAsString(idleScript);
        await Process.start('chmod', ['+x', scriptFile.path]);

        Process.run(scriptFile.path, []);
      } catch (e) {
        throw const SystemIdleException(message: unknownError);
      }
    }
  }

  String _generateIdleScript(int idleTime) {
    return '''
#!/bin/bash

idleloop() {
    touch /tmp/.input
    touch /tmp/.last_input
    touch /tmp/.is_idle
    echo "false" > /tmp/.is_idle
    
    cmd='stat --printf="%s"'
    idletime=$idleTime
    a=2
    t=0
    while true
    do
        timeout 1 xinput test-xi2 --root > /tmp/.input
            
        if [[ `eval \$cmd /tmp/.input` == `eval \$cmd /tmp/.last_input` ]]
        then
            let t++ # increases \$t by 1
        else
            t=0     # resets \$t
        fi

        mv /tmp/.input /tmp/.last_input -f

        if [ \$t -ge \$idletime ] && [[ \$a == "2" ]]
        then
            echo "user has gone idle"
            echo "true" > /tmp/.is_idle
            a=1
        fi
        if [ \$t -lt \$idletime ] && [[ \$a == "1" ]]
        then
            echo "user has come back from idle"
            echo "false" > /tmp/.is_idle
            a=2
        fi
    done
}

idleloop 2>&1 | tee idle.log
''';
  }

  /// Returns whether system is in idle state after given amout of time in milliseconds
  ///
  /// Throws a [SystemIdleException] if an error occurs.
  Future<bool> isIdle() async {
    if (!Platform.isLinux) {
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
          throw const SystemIdleException(
              message: 'System returned null value');
        }

        return isIdle;
      } catch (_) {
        throw const SystemIdleException(message: unknownError);
      }
    } else {
      final isIdleFile = File('/tmp/.is_idle');
      final isIdle = await isIdleFile.readAsString();

      return isIdle.contains('true');
    }
  }
}
