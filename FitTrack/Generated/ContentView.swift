import SwiftUI

struct ContentView: View {
    @StateObject private var workoutViewModel = WorkoutViewModel()
    @State private var selectedTab = 0
    
    var body: some View {
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
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
                .tag(3)
        }
        .accentColor(.purple)
    }
}