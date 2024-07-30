import "dart:async";

import "interface.dart";

/// A timer-based approach to [SystemIdlePlatformInterface].
///
/// This class uses a [StreamController] to start and stop a [Timer] that periodically
/// checks [getIdleDuration] and compares it to the duration provided to [onIdleChanged].
mixin SystemIdleTimer on SystemIdlePlatformInterface {
  Timer? _timer;
  bool _isIdle = false;

  // This will never be unassigned when it's needed:
  //
  // - [_startListening] can only be used when the [_controller] is listened to. The
  // controller's stream can only be obtained using [onIdleFor], which sets this.
  //
  // - [_checkIdle] uses this, but it will only be called after [_startListening].
  late Duration _idleDuration;

  late final _controller = StreamController<bool>(
    onListen: _startListening,
    onCancel: _stopListening,
    onPause: _stopListening,
    onResume: _startListening,
  );

  void _startListening() => _timer = Timer.periodic(_idleDuration, _checkIdle);

  void _stopListening() {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> _checkIdle([_]) async {
    final duration = await getIdleDuration();
    final newIdleState = duration >= _idleDuration;
    if (_isIdle != newIdleState) {
      _controller.add(newIdleState);
      _isIdle = newIdleState;
    }
  }

  @override
  Future<void> dispose() async {
    _timer?.cancel();
    await _controller.close();
    await super.dispose();
  }

  @override
  Stream<bool> onIdleChanged({required Duration idleDuration}) {
    _idleDuration = idleDuration;
    return _controller.stream;
  }
}
