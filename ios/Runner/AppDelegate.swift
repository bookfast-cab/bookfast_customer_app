import UIKit
import Flutter
import FirebaseCore
import FirebaseMessaging
import Firebase
import GoogleMaps


@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
       FirebaseApp.configure()
      GMSServices.provideAPIKey("AIzaSyCV0gjfvF_AjQcME2SKRZ9uOCzLRaoOOW4") // Approach

    GeneratedPluginRegistrant.register(with: self)

     if #available(iOS 10.0, *) {
                    UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
                   }else {
                              let settings: UIUserNotificationSettings =
                              UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
                              application.registerUserNotificationSettings(settings)
                          }

                application.registerForRemoteNotifications()
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
