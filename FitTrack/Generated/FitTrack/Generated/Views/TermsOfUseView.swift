import SwiftUI

struct TermsOfUseView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Terms of Use")
                    .font(.title)
                    .bold()
                    .padding(.bottom, 10)
                
                Group {
                    Text("1. Acceptance of Terms")
                        .font(.headline)
                    Text("By downloading, installing, or using FitTrack, you agree to be bound by these Terms of Use. If you do not agree to these terms, please do not use the app.")
                    
                    Text("2. Use License")
                        .font(.headline)
                    Text("FitTrack grants you a limited, non-exclusive, non-transferable license to use the app for your personal, non-commercial purposes.")
                    
                    Text("3. User Data")
                        .font(.headline)
                    Text("You retain all rights to your personal workout and health data. We do not claim ownership of your data but require access to provide the service.")
                    
                    Text("4. Restrictions")
                        .font(.headline)
                    Text("You agree not to:\n• Modify or reverse engineer the app\n• Use the app for illegal purposes\n• Transfer your account to another person")
                    
                    Text("5. Privacy")
                        .font(.headline)
                    Text("Your privacy is important to us. Please review our Privacy Policy to understand how we collect and use your data.")
                    
                    Text("6. Modifications")
                        .font(.headline)
                    Text("We reserve the right to modify these terms at any time. Continued use of the app after changes constitutes acceptance of the new terms.")
                }
                
                Spacer()
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}