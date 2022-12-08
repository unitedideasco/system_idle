import 'dart:io';

import 'package:flutter/material.dart';
import 'package:system_idle/system_idle.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'System Idle Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SystemIdleExample(),
    );
  }
}

class SystemIdleExample extends StatefulWidget {
  const SystemIdleExample({Key? key}) : super(key: key);

  @override
  State<SystemIdleExample> createState() => _SystemIdleExampleState();
}

class _SystemIdleExampleState extends State<SystemIdleExample> {
  final _systemIdle = SystemIdle.instance;

  bool _isIdle = false;

  @override
  void initState() {
    super.initState();
    _configureSystemIdle();
  }

  void _configureSystemIdle() async {
    await _systemIdle.initialize(time: 10);

    _systemIdle.onIdleStateChanged.listen(
      (isIdle) => setState(() => _isIdle = isIdle),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('System Idle Example'),
      ),
      body: Column(children: [
        Text(
          'Is idle state: $_isIdle',
          style: const TextStyle(fontSize: 40.0),
        ),
        Text(
          Platform.resolvedExecutable,
          style: const TextStyle(fontSize: 40.0),
        ),
      ]),
    );
  }
}
