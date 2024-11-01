import "interface.dart";

/// An implementation of system_idle for devices that don't support it.
class SystemIdleStub extends SystemIdlePlatformInterface {
  @override
  Future<void> initialize() async { }

  @override
  bool get isSupported => false;

  @override
  Future<Duration?> getIdleDuration() async => null;

  @override
  Stream<bool> onIdleChanged({required Duration idleDuration}) => const Stream.empty();
}
