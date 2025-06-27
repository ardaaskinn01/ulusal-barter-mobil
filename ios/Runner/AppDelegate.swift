import UIKit
import Flutter
import OneSignal

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    // OneSignal başlat
    OneSignal.initialize("d4f432ca-d0cc-4d13-873d-b24b41de5699") // ← Buraya kendi OneSignal App ID'ni yaz

    // Bildirim yetkisi iste (opsiyonel ama önerilir)
    OneSignal.Notifications.requestPermission({ accepted in
        print("Notification permission: \(accepted)")
    }, fallbackToSettings: true)

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
