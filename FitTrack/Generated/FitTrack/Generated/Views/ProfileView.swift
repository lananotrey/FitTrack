import SwiftUI

struct ProfileView: View {
    @AppStorage("userName") private var userName = ""
    @AppStorage("userWeight") private var userWeight = ""
    @AppStorage("userHeight") private var userHeight = ""
    @AppStorage("userAge") private var userAge = ""
    @State private var isEditing = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Personal Information")) {
                    if isEditing {
                        TextField("Name", text: $userName)
                        TextField("Weight (kg)", text: $userWeight)
                            .keyboardType(.decimalPad)
                        TextField("Height (cm)", text: $userHeight)
                            .keyboardType(.numberPad)
                        TextField("Age", text: $userAge)
                            .keyboardType(.numberPad)
                    } else {
                        InfoRow(title: "Name", value: userName)
                        InfoRow(title: "Weight", value: "\(userWeight) kg")
                        InfoRow(title: "Height", value: "\(userHeight) cm")
                        InfoRow(title: "Age", value: userAge)
                    }
                }
                
                Section(header: Text("App Settings")) {
                    NavigationLink(destination: NotificationsSettingsView()) {
                        Label("Notifications", systemImage: "bell.fill")
                    }
                    
                    NavigationLink(destination: AppearanceSettingsView()) {
                        Label("Appearance", systemImage: "paintbrush.fill")
                    }
                }
                
                Section(header: Text("About")) {
                    Link(destination: URL(string: "https://www.fittrack.com/privacy")!) {
                        Label("Privacy Policy", systemImage: "lock.fill")
                    }
                    
                    Link(destination: URL(string: "https://www.fittrack.com/terms")!) {
                        Label("Terms of Service", systemImage: "doc.text.fill")
                    }
                    
                    Label("Version 1.0.0", systemImage: "info.circle.fill")
                }
            }
            .navigationTitle("Profile")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        withAnimation {
                            isEditing.toggle()
                        }
                    }) {
                        Text(isEditing ? "Done" : "Edit")
                    }
                }
            }
        }
    }
}

struct InfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Text(value)
                .foregroundColor(.secondary)
        }
    }
}

struct NotificationsSettingsView: View {
    @AppStorage("workoutReminders") private var workoutReminders = true
    @AppStorage("goalAlerts") private var goalAlerts = true
    
    var body: some View {
        Form {
            Section(header: Text("Notifications")) {
                Toggle("Workout Reminders", isOn: $workoutReminders)
                Toggle("Goal Alerts", isOn: $goalAlerts)
            }
        }
        .navigationTitle("Notifications")
    }
}

struct AppearanceSettingsView: View {
    @AppStorage("darkMode") private var darkMode = false
    
    var body: some View {
        Form {
            Section(header: Text("Theme")) {
                Toggle("Dark Mode", isOn: $darkMode)
            }
        }
        .navigationTitle("Appearance")
    }
}