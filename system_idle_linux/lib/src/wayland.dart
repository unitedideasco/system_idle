import "dart:async";
import "dart:ffi";

import "package:system_idle_platform_interface/system_idle_platform_interface.dart";

import "wayland_bindings.dart";

/// An implementation of system_idle for Wayland-based Linux systems.
class SystemIdleWayland extends SystemIdlePlatformInterface {
  final String _libraryPath;
  late final _library = DynamicLibrary.open(_libraryPath);
  late final _bindings = SystemIdleWaylandBindings(_library);
  late final _controller = StreamController<bool>.broadcast(
    onListen: () => _isListening = true,
    onCancel: () => _isListening = false,
  );

  /// Opens the wayland binaries on Linux.
  SystemIdleWayland({String libraryPath = "libsystem_idle_linux_wayland.so"}) :
    _libraryPath = libraryPath;

  Pointer<WaylandPlugin> _plugin = nullptr;
  bool _isListening = false;
  Timer? _pollTimer;

  @override
  bool isSupported = false;

  @override
  Future<void> initialize() async {
    final callback = NativeCallable<IdleCallbackFunction>.listener(_handleIdleEvent);
    _plugin = _bindings.createPlugin();
    isSupported = _bindings.initPlugin(_plugin, callback.nativeFunction);
    _pollTimer = Timer.periodic(const Duration(seconds: 1), (_) => _bindings.pollEvents(_plugin));
  }

  @override
  Future<void> dispose() async {
    if (_plugin != nullptr) _bindings.freePlugin(_plugin);
    _pollTimer?.cancel();
    _plugin = nullptr;
    await super.dispose();
  }

  void _handleIdleEvent(bool isIdle) {
    if (!_isListening) return;
    _controller.add(isIdle);
  }

  @override
  Future<Duration?> getIdleDuration() async => null;  // not supported

  @override
  Stream<bool> onIdleChanged({required Duration idleDuration}) {
    if (_plugin == nullptr) throw StateError("You must call SystemIdleLinux.init() before onIdleChanged()");
    _bindings.listenForIdleEvents(_plugin, idleDuration.inMilliseconds);
    return _controller.stream;
  }
}
