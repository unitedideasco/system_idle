import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:system_idle/src/system_idle.dart';
import 'package:watcher/watcher.dart';

const _idleFilePath = '/tmp/.is_idle';

class SystemIdleCheckerLinux extends SystemIdleChecker {
  final _controller = StreamController<bool>.broadcast();

  @override
  Future<void> initialize({int time = defaultIdleTime}) async {
    try {
      Process.run('killall', ['-9', 'idle']);
    } catch (_) {
      log('Could not kill remaining idle processes');
    }

    try {
      final execFile = File(Platform.resolvedExecutable);
      final scriptFile = File(p.join(execFile.parent.path, 'idle'));

      final idleScript = _generateIdleScript(time);
      await scriptFile.writeAsString(idleScript);
      await Process.start('chmod', ['+x', scriptFile.path]);

      await Process.run(scriptFile.path, []);

      Timer.periodic(const Duration(seconds: 1), (timer) async {
        FileWatcher(_idleFilePath).events.listen((event) {
          if (event.type == ChangeType.REMOVE) {
            _controller.sink.add(false);
            return;
          }

          final contents = File(_idleFilePath).readAsStringSync();
          final isIdle = contents.contains('true');

          _controller.sink.add(isIdle);
        });
      });
    } catch (e) {
      throw const SystemIdleException(message: unknownError);
    }
  }

  @override
  Stream<bool> onIdleStateChanged() => _controller.stream;

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
}
