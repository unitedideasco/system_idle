// Okay to print in a test script.
// ignore_for_file: avoid_print

import "dart:io";

import "package:system_idle_linux/system_idle_linux.dart";

void main() async {
  final plugin = SystemIdleLinux.forWindowManager();
  await plugin.initialize();
  if (!plugin.isSupported) {
    print("This distribution does not support idle detection");
    return;
  }
  var isIdle = false;
  plugin.onIdleChanged(idleDuration: const Duration(seconds: 5))
    .listen((value) => isIdle = value);
  print("\n");
  while (true) {
    final idleDuration = await plugin.getIdleDuration();
    final timeMessage = idleDuration == null ? "" : "User has been idle for ${idleDuration.inSeconds} seconds.";
    final idleMessage = "Is idle? $isIdle";
    final message = "$timeMessage $idleMessage";
    final paddedMessage = message.padRight(message.length + 5);
    stdout.write("\r$paddedMessage");
    await stdout.flush();
    await Future<void>.delayed(const Duration(milliseconds: 500));
  }
}
