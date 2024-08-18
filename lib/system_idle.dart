import "dart:io";

import "src/interface.dart";
import "src/system_idle_linux.dart";
import "src/system_idle_macos.dart";
import "src/system_idle_windows.dart";

class SystemIdle {
  static const defaultIdleDuration = Duration(minutes: 5);

  SystemIdle._() {
    if (Platform.isWindows) {
      _systemIdleChecker = SystemIdleCheckerWindows();
    } else if (Platform.isMacOS) {
      _systemIdleChecker = SystemIdleCheckerMacOS();
    } else if (Platform.isLinux) {
      _systemIdleChecker = SystemIdleCheckerLinux();
    }
  }

  static final SystemIdle _instance = SystemIdle._();

  /// A singleton instance of [SystemIdle] class
  static SystemIdle get instance => _instance;

  late SystemIdleChecker _systemIdleChecker;

  /// {@macro system_idle_initialize}
  Future<void> initialize({Duration duration = defaultIdleDuration}) =>
      _systemIdleChecker.initialize(duration: duration);

  /// {@macro system_idle_on_idle_state_changed}
  Stream<bool> get onIdleStateChanged =>
      _systemIdleChecker.onIdleStateChanged();

  /// {@macro system_idle_get_idle_duration}
  Future<Duration> getIdleDuration() => _systemIdleChecker.getIdleDuration();

  /// {@macro dispose}
  void dispose() => _systemIdleChecker.dispose();
}
