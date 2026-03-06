import Flutter
import UIKit
import FirebaseCore

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()
    GeneratedPluginRegistrant.register(with: self)

    // Handle URL scheme from cold start
    if let url = launchOptions?[.url] as? URL {
      return handleUrl(url)
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    return handleUrl(url)
  }

  private func handleUrl(_ url: URL) -> Bool {
    print("📱 Received URL: \(url.absoluteString)")

    if url.scheme == "voicebubble" && url.host == "shared" {
      // Post notification to Flutter
      NotificationCenter.default.post(name: NSNotification.Name("SharedContentReceived"), object: nil)
      return true
    }
    return false
  }
}