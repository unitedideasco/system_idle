import "dart:async";

import "package:meta/meta.dart";

/// The platform interface for the `system_idle` package.
///
/// This package does not consider additions to be breaking changes, so avoid implementing this
/// class when you can extend it instead.
abstract class SystemIdlePlatformInterface {
  /// Initializes the plugin.
  Future<void> initialize();

  /// Releases any resources associated with this object.
  ///
  /// Once you call this, this object may not be used again, and any streams returned by
  /// [onIdleChanged] will stop emitting events.
  @mustCallSuper
  Future<void> dispose() async { }

  /// Returns a stream that emits when the user becomes idle (true) or active (false).
  Stream<bool> onIdleChanged({required Duration idleDuration});

  /// Returns how long the user has been idle for already.
  Future<Duration?> getIdleDuration();

  bool get isSupported => true;
}
