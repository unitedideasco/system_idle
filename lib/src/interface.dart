abstract class SystemIdleChecker {
  /// {@template system_idle_initialize}
  /// Initializes SystemIdle plugin with given time
  /// If time is not provided the default time is used;
  /// {@endtemplate}
  Future<void> initialize({required Duration duration});

  /// {@template system_idle_on_idle_state_changed}
  /// Returns a bool stream with changes of the idle state
  /// {@endtemplate}
  Stream<bool> onIdleStateChanged();

  // Returns how long the user has been idle for already.
  Future<Duration> getIdleDuration();
}

class SystemIdleException implements Exception {
  const SystemIdleException({required this.message});

  final String message;
}
