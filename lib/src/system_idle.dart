import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:system_idle/src/system_idle_linux.dart';
import 'package:system_idle/src/system_idle_macos.dart';
import 'package:system_idle/src/system_idle_windows.dart';

const couldNotInitialize = 'Could not initialize the plugin';
const notInitialized = 'Plugin has not been initialized. Call initialize first';
const systemReturnedNull = 'System returned null value';
const unknownError = 'Unknown error';

const defaultIdleTime = 300;

abstract class SystemIdleChecker {
  /// {@template system_idle_initialize}
  /// Initializes SystemIdle plugin with given time in seconds
  /// If time is not provided the default time is used;
  /// {@endtemplate}
  Future<void> initialize({int time = defaultIdleTime});

  /// {@template system_idle_on_idle_state_changed}
  /// Returns a bool stream with changes of the idle state
  /// {@endtemplate}
  Stream<bool> onIdleStateChanged();
}

class SystemIdleException implements Exception {
  const SystemIdleException({required this.message});

  final String message;
}

class SystemIdle {
  SystemIdle._() {
    if (Platform.isWindows) {
      _systemIdleChecker = SystemIdleCheckerWindows();
    } else if (Platform.isMacOS) {
      _systemIdleChecker = SystemIdleCheckerMacOS();
    } else if (Platform.isLinux) {
      _systemIdleChecker = SystemIdleCheckerLinux();
    }
  }

  static final SystemIdle _instance = SystemIdle._();

  /// A singleton instance of [SystemIdle] class
  static SystemIdle get instance => _instance;

  late SystemIdleChecker _systemIdleChecker;

  /// {@macro system_idle_initialize}
  Future<void> initialize({int time = defaultIdleTime}) =>
      _systemIdleChecker.initialize(time: time);

  /// {@macro system_idle_on_idle_state_changed}
  Stream<bool> get onIdleStateChanged =>
      _systemIdleChecker.onIdleStateChanged();
/* 
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
  } */
}
