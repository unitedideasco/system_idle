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
            case "isIdle":
                let idleTime: Int? = (call.arguments as? [String: Any])?["idleTime"] as? Int
                result(isIdle(idleTime: idleTime))
            default:
                result(FlutterMethodNotImplemented)
        }
    }

    private func isIdle(idleTime: Int?) -> Bool {
        
        var isIdle = false
        
        var lastEvent:CFTimeInterval = 0
        lastEvent = CGEventSource.secondsSinceLastEventType(CGEventSourceStateID.hidSystemState,
                                                            eventType: CGEventType(rawValue: ~0)!)
        
        if(Int(lastEvent) > idleTime!) {
            isIdle = true
        }
        
        return isIdle;
    }
}



