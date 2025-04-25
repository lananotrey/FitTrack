import SwiftUI
import FirebaseCore
import FirebaseRemoteConfig

@main
struct FitTrackApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            RemoteScreen()
        }
    }
}
