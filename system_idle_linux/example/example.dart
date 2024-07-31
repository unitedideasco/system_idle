import "dart:io";

import "package:system_idle_linux/system_idle_linux.dart";

void main() async {
  final plugin = SystemIdleLinux();
  bool isIdle = false;
  await plugin.initialize();
  plugin.onIdleChanged(idleDuration: Duration(seconds: 5))
    .listen((value) => isIdle = value);
  print("\n");
  while (true) {
    final idleDuration = await plugin.getIdleDuration();
    final message = "User has been idle for ${idleDuration.inSeconds} seconds. Is idle? $isIdle";
    final paddedMessage = message.padRight(message.length + 5);
    stdout.write("\r$paddedMessage");
    stdout.flush();
    await Future<void>.delayed(const Duration(milliseconds: 500));
  }
}
