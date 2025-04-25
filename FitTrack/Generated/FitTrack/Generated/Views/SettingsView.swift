import SwiftUI

struct SettingsView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Appearance").foregroundColor(.primary)) {
                    Toggle(isOn: $isDarkMode) {
                        Label {
                            Text("Dark Mode")
                                .foregroundColor(.primary)
                        } icon: {
                            Image(systemName: "moon.fill")
                                .foregroundColor(.purple)
                        }
                    }
                    .tint(.purple)
                    .onChange(of: isDarkMode) { _ in
                        updateAppearance()
                    }
                }
                
                Section(header: Text("About").foregroundColor(.primary)) {
                    Button(action: rateApp) {
                        Label {
                            Text("Rate this app")
                                .foregroundColor(.primary)
                        } icon: {
                            Image(systemName: "star.fill")
                                .foregroundColor(.purple)
                        }
                    }
                    
                    Button(action: shareApp) {
                        Label {
                            Text("Share this app")
                                .foregroundColor(.primary)
                        } icon: {
                            Image(systemName: "square.and.arrow.up")
                                .foregroundColor(.purple)
                        }
                    }
                    
                    NavigationLink {
                        TermsOfUseView()
                    } label: {
                        Label {
                            Text("Terms of Use")
                                .foregroundColor(.primary)
                        } icon: {
                            Image(systemName: "doc.text")
                                .foregroundColor(.purple)
                        }
                    }
                    
                    NavigationLink {
                        PrivacyPolicyView()
                    } label: {
                        Label {
                            Text("Privacy Policy")
                                .foregroundColor(.primary)
                        } icon: {
                            Image(systemName: "lock.shield")
                                .foregroundColor(.purple)
                        }
                    }
                }
                
                Section(header: Text("App Info").foregroundColor(.primary)) {
                    HStack {
                        Text("Version")
                            .foregroundColor(.primary)
                        Spacer()
                        Text(Bundle.main.appVersionLong)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Settings")
            .background(Color(UIColor.systemBackground))
        }
    }
    
    private func updateAppearance() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            windowScene.windows.first?.overrideUserInterfaceStyle = isDarkMode ? .dark : .light
        }
    }
    
    private func rateApp() {
        guard let appStoreURL = URL(string: "https://apps.apple.com/app/idYOUR_APP_ID") else { return }
        UIApplication.shared.open(appStoreURL, options: [:], completionHandler: nil)
    }
    
    private func shareApp() {
        guard let appStoreURL = URL(string: "https://apps.apple.com/app/idYOUR_APP_ID") else { return }
        let activityVC = UIActivityViewController(
            activityItems: ["Check out FitTrack!", appStoreURL],
            applicationActivities: nil
        )
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first,
           let rootVC = window.rootViewController {
            activityVC.popoverPresentationController?.sourceView = rootVC.view
            rootVC.present(activityVC, animated: true)
        }
    }
}

extension Bundle {
    var appVersionLong: String {
        return "\(appVersionShort) (\(buildNumber))"
    }
    
    private var appVersionShort: String {
        return infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    }
    
    private var buildNumber: String {
        return infoDictionary?["CFBundleVersion"] as? String ?? "1"
    }
}