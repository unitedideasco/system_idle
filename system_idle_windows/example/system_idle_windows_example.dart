import "dart:io";

import 'package:system_idle_windows/system_idle_windows.dart';

void main() async {
  final plugin = SystemIdleWindows();
  bool isIdle = false;
  await plugin.initialize();
  plugin.onIdleChanged(idleDuration: Duration(seconds: 5))
    .listen((value) => isIdle = value);
  print("\n");
  while (true) {
    final idleDuration = await plugin.getIdleDuration();
    stdout.write("\rUse has been idle for ${idleDuration.inSeconds} seconds. Is idle? $isIdle");
    await Future<void>.delayed(const Duration(milliseconds: 500));
  }
}
