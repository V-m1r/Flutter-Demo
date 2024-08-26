import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
        let screenshotChannel = FlutterMethodChannel(name: "screenshot",
                                                     binaryMessenger: controller.binaryMessenger)
        
        screenshotChannel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
            if call.method == "captureScreenshot" {
                ScreenshotService.shared.captureScreenshot { filePath in
                    if let path = filePath {
                        result(path)
                    } else {
                        result(FlutterError(code: "UNAVAILABLE", message: "Screenshot capture failed", details: nil))
                    }
                }
            } else {
                result(FlutterMethodNotImplemented)
            }
        }
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
