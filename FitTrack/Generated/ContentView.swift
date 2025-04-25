import SwiftUI

struct ContentView: View {
    @StateObject private var workoutViewModel = WorkoutViewModel()
    @State private var selectedTab = 0
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    
    var body: some View {
        Group {
            if !hasCompletedOnboarding {
                OnboardingScreen()
            } else {
                TabView(selection: $selectedTab) {
                    DashboardView(viewModel: workoutViewModel)
                        .tabItem {
                            Image(systemName: "chart.bar.fill")
                            Text("Dashboard")
                        }
                        .tag(0)
                    
                    WorkoutListView(viewModel: workoutViewModel)
                        .tabItem {
                            Image(systemName: "figure.run")
                            Text("Workouts")
                        }
                        .tag(1)
                    
                    GoalsView(viewModel: workoutViewModel)
                        .tabItem {
                            Image(systemName: "flag.fill")
                            Text("Goals")
                        }
                        .tag(2)
                    
                    SettingsView()
                        .tabItem {
                            Image(systemName: "gearshape.fill")
                            Text("Settings")
                        }
                        .tag(3)
                }
                .accentColor(.purple)
            }
        }
    }
}