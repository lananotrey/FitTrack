import SwiftUI
import FirebaseCore
import FirebaseRemoteConfig
import FirebaseMessaging
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate {
   func application(
       _ application: UIApplication,
       didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
   ) -> Bool {
       FirebaseApp.configure()
       configureRemoteConfig()
       configureNotifications(application)
       AppRatingManager.shared.incrementLaunchCount()
       return true
   }
   
   private func configureRemoteConfig() {
       let config = RemoteConfig.remoteConfig()
       let settings = RemoteConfigSettings()
       settings.minimumFetchInterval = 0
       config.configSettings = settings
   }
   
   private func configureNotifications(_ application: UIApplication) {
       UNUserNotificationCenter.current().delegate = self
       
       let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
       UNUserNotificationCenter.current().requestAuthorization(
           options: authOptions,
           completionHandler: { _, _ in }
       )
       
       application.registerForRemoteNotifications()
       
       Messaging.messaging().delegate = self
   }
   
   func application(_ application: UIApplication,
                   didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
       Messaging.messaging().apnsToken = deviceToken
   }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
   func userNotificationCenter(
       _ center: UNUserNotificationCenter,
       willPresent notification: UNNotification,
       withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
   ) {
       completionHandler([[.banner, .sound]])
   }
   
   func userNotificationCenter(
       _ center: UNUserNotificationCenter,
       didReceive response: UNNotificationResponse,
       withCompletionHandler completionHandler: @escaping () -> Void
   ) {
       completionHandler()
   }
}

extension AppDelegate: MessagingDelegate {
   func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
       guard let token = fcmToken else { return }
       print("FCM token: \(token)")
   }
}
