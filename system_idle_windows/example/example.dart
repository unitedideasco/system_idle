// ignore_for_file: avoid_print

import "dart:io";

import "package:system_idle_windows/system_idle_windows.dart";

void main() async {
  final plugin = SystemIdleWindows();
  var isIdle = false;
  await plugin.initialize();
  plugin.onIdleChanged(idleDuration: const Duration(seconds: 5))
    .listen((value) => isIdle = value);
  print("\n");
  while (true) {
    final idleDuration = await plugin.getIdleDuration();
    final message = "User has been idle for ${idleDuration.inSeconds} seconds. Is idle? $isIdle";
    final paddedMessage = message.padRight(message.length + 5);
    stdout.write("\r$paddedMessage");
    await stdout.flush();
    await Future<void>.delayed(const Duration(milliseconds: 500));
  }
}
