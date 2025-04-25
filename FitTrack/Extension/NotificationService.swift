import UserNotifications
import FirebaseMessaging

final class NotificationService {
    static let shared = NotificationService()
    
    private init() {}
    
    func subscribeToTopic(_ topic: String) {
        Messaging.messaging().subscribe(toTopic: topic) { error in
            if let error = error {
                print("Failed to subscribe to topic: \(error.localizedDescription)")
            }
        }
    }
    
    func unsubscribeFromTopic(_ topic: String) {
        Messaging.messaging().unsubscribe(fromTopic: topic) { error in
            if let error = error {
                print("Failed to unsubscribe from topic: \(error.localizedDescription)")
            }
        }
    }
    
    func getFCMToken() -> String? {
        return Messaging.messaging().fcmToken
    }
}
