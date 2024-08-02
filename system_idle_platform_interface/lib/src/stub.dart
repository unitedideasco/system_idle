import "interface.dart";

class SystemIdleStub extends SystemIdlePlatformInterface {
  @override
  Future<void> initialize() async { }

  @override
  bool get isSupported => false;

  @override
  Future<Duration?> getIdleDuration() async => null;

  @override
  Stream<bool> onIdleChanged({required Duration idleDuration}) => Stream.empty(broadcast: true);
}
