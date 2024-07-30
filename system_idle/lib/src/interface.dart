abstract class SystemIdleChecker {
  /// {@template system_idle_initialize}
  /// Initializes the plugin to fire [onIdleStateChanged] when the user is idle for [duration].
  ///
  /// This method is idempotent, so you can call it again with a different duration. The default
  /// duration is 5 minutes.
  /// {@endtemplate}
  Future<void> initialize({required Duration duration});

  /// {@template system_idle_on_idle_state_changed}
  /// Returns a bool stream with changes of the idle state
  /// {@endtemplate}
  Stream<bool> onIdleStateChanged();

  /// {@template system_idle_get_idle_duration}
  /// Returns how long the user has been idle for already.
  /// {@endtemplate}
  Future<Duration> getIdleDuration();

  /// {@template system_idle_dispose}
  /// Releases any resources associated with this object.
  ///
  /// Once you call this, this object may not be used again.
  /// {@endtemplate}
  void dispose();
}

class SystemIdleException implements Exception {
  const SystemIdleException({required this.message});

  final String message;
}
