import "dart:io";

import 'package:system_idle_windows/system_idle_windows.dart';

void main() async {
  final plugin = SystemIdleWindows();
  await plugin.initialize();
  plugin.onIdleChanged(idleDuration: Duration(seconds: 5))
    .listen((isIdle) => stdout.write(isIdle ? "\rUser is idle!" : "\rUser is active again!"));
  print("\n");
  while (true) {
    final idleDuration = await plugin.getIdleDuration();
    stdout.write("\rUse has been idle for ${idleDuration.inSeconds} seconds");
    await Future<void>.delayed(const Duration(seconds: 1));
  }
}
