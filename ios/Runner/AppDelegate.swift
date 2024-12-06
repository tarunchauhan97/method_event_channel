import UIKit
import Flutter
import CoreMotion

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    private let ACCELEROMETER_CHANNEL = "com.tarun/accelerometer"
    private let motionManager = CMMotionManager()
    private var eventSink: FlutterEventSink?

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller = window?.rootViewController as! FlutterViewController
        let eventChannel = FlutterEventChannel(name: ACCELEROMETER_CHANNEL, binaryMessenger: controller.binaryMessenger)
        eventChannel.setStreamHandler(self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}

extension AppDelegate: FlutterStreamHandler {
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        eventSink = events
        if motionManager.isAccelerometerAvailable {
            motionManager.accelerometerUpdateInterval = 0.1
            motionManager.startAccelerometerUpdates(to: .main) { (data, error) in
                if let error = error {
                    eventSink?(FlutterError(code: "ACCELEROMETER_ERROR", message: error.localizedDescription, details: nil))
                } else if let data = data {
                    let result: [String: Double] = [
                        "x": data.acceleration.x,
                        "y": data.acceleration.y,
                        "z": data.acceleration.z
                    ]
                    eventSink?(result)
                }
            }
        } else {
            return FlutterError(code: "ACCELEROMETER_UNAVAILABLE", message: "Accelerometer not available", details: nil)
        }
        return nil
    }

    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        motionManager.stopAccelerometerUpdates()
        eventSink = nil
        return nil
    }
}

