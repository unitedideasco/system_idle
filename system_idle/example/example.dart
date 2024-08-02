import "dart:async";

import "package:flutter/material.dart";
import "package:system_idle/system_idle.dart";

final plugin = SystemIdle.forPlatform();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await plugin.initialize();
  runApp(MaterialApp(home: HomePage()));
}

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  bool isIdle = false;
  Duration? duration;
  StreamSubscription<bool>? _sub;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _sub = plugin.onIdleChanged(idleDuration: Duration(seconds: 3)).listen(_onIdleChanged);
    _timer = Timer.periodic(Duration(seconds: 1), _checkTime);
  }

  @override
  void dispose() {
    _sub?.cancel();
    _timer?.cancel();
    super.dispose();
  }

  void _onIdleChanged(bool value) => setState(() => isIdle = value);
  void _checkTime(Timer timer) async {
    final idleDuration = await plugin.getIdleDuration();
    setState(() => duration = idleDuration);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text("Idle detector demo")),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (!plugin.isSupported) ...[
            Text("Idle detection is not supported on your device"),
          ] else ...[
            if (duration == null) Text("Your device does not support checking how long the user is idle")
            else Text("The user has been idle for: ${duration!.inSeconds} seconds"),
            Text("The user is ${isIdle ? "" : "not "}idle"),
          ],
        ],
      ),
    ),
  );
}
