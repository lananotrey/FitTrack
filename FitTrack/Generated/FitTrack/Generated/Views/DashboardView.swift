import SwiftUI
import Charts

struct DashboardView: View {
    @ObservedObject var viewModel: WorkoutViewModel
    @State private var selectedTimeFrame: TimeFrame = .week
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    HeaderCard()
                    
                    StatisticsSection(viewModel: viewModel)
                    
                    WorkoutChart(viewModel: viewModel, timeFrame: selectedTimeFrame)
                    
                    RecentWorkoutsSection(viewModel: viewModel)
                }
                .padding()
            }
            .navigationTitle("Dashboard")
            .background(Color(.systemGray6))
        }
    }
}

struct HeaderCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Welcome back!")
                .font(.title)
                .bold()
            
            Text("Keep up the great work! 💪")
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(LinearGradient(gradient: Gradient(colors: [.purple, .blue]),
                                   startPoint: .topLeading,
                                   endPoint: .bottomTrailing))
        )
        .foregroundColor(.white)
    }
}

struct StatisticsSection: View {
    @ObservedObject var viewModel: WorkoutViewModel
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 15), count: 2), spacing: 15) {
            StatCard(title: "Total Workouts", value: "\(viewModel.workouts.count)", icon: "figure.run")
            StatCard(title: "Active Goals", value: "\(viewModel.goals.count)", icon: "flag.fill")
            StatCard(title: "This Week", value: "\(viewModel.workoutsThisWeek)", icon: "calendar")
            StatCard(title: "Streak", value: "\(viewModel.currentStreak) days", icon: "flame.fill")
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.purple)
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Text(value)
                .font(.title2)
                .bold()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 2)
    }
}

struct RecentWorkoutsSection: View {
    @ObservedObject var viewModel: WorkoutViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Recent Workouts")
                .font(.title2)
                .bold()
            
            ForEach(viewModel.recentWorkouts) { workout in
                WorkoutRow(workout: workout)
            }
        }
    }
}