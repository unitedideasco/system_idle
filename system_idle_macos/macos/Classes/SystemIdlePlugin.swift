import Cocoa
import FlutterMacOS


public class SystemIdlePlugin: NSObject, FlutterPlugin {

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "unitedideas.co/system_idle", binaryMessenger: registrar.messenger)
        let instance = SystemIdlePlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
            case "getIdleTime":
                result(getIdleTime());
            default:
                result(FlutterMethodNotImplemented)
        }
    }

    private func getIdleTime() -> Int {
        var lastEvent:CFTimeInterval = 0
        lastEvent = CGEventSource.secondsSinceLastEventType(
            CGEventSourceStateID.hidSystemState,
            eventType: CGEventType(rawValue: ~0)!
        );
        return Int(lastEvent);
    }
}
