import SwiftUI

struct PrivacyPolicyView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Privacy Policy")
                    .font(.title)
                    .bold()
                    .padding(.bottom, 10)
                
                Group {
                    Text("Information We Collect")
                        .font(.headline)
                    Text("FitTrack collects the following types of information:\n• Workout data\n• Fitness goals\n• Basic profile information\n• Device information")
                    
                    Text("How We Use Your Information")
                        .font(.headline)
                    Text("We use your information to:\n• Provide and improve our services\n• Track your fitness progress\n• Personalize your experience\n• Send important updates")
                    
                    Text("Data Storage")
                        .font(.headline)
                    Text("Your data is stored securely on your device and in our encrypted cloud storage. We implement appropriate security measures to protect your information.")
                    
                    Text("Third-Party Services")
                        .font(.headline)
                    Text("We may use third-party services that collect information. These services have their own privacy policies and terms of use.")
                    
                    Text("Your Rights")
                        .font(.headline)
                    Text("You have the right to:\n• Access your data\n• Correct inaccurate data\n• Delete your data\n• Export your data")
                    
                    Text("Contact Us")
                        .font(.headline)
                    Text("If you have questions about this privacy policy, please contact us at: support@fittrack.com")
                }
                
                Spacer()
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}