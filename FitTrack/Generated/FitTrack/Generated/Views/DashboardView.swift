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
                    
                    ActiveGoalsSection(goals: viewModel.activeGoals)
                    
                    WorkoutChart(viewModel: viewModel, timeFrame: selectedTimeFrame)
                    
                    RecentWorkoutsSection(viewModel: viewModel)
                }
                .padding()
            }
            .navigationTitle("Dashboard")
            .background(Color(.systemGroupedBackground))
        }
    }
}

struct HeaderCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Welcome back!")
                .font(.title)
                .bold()
                .foregroundColor(.white)
            
            Text("Keep up the great work! 💪")
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(LinearGradient(gradient: Gradient(colors: [.purple, .blue]),
                                   startPoint: .topLeading,
                                   endPoint: .bottomTrailing))
        )
    }
}

struct StatisticsSection: View {
    @ObservedObject var viewModel: WorkoutViewModel
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 15), count: 2), spacing: 15) {
            StatCard(title: "Total Workouts", value: "\(viewModel.workouts.count)", icon: "figure.run")
            StatCard(title: "Active Goals", value: "\(viewModel.activeGoals.count)", icon: "flag.fill")
            StatCard(title: "This Week", value: "\(viewModel.workoutsThisWeek)", icon: "calendar")
            StatCard(title: "Streak", value: "\(viewModel.currentStreak) days", icon: "flame.fill")
        }
    }
}

struct ActiveGoalsSection: View {
    let goals: [Goal]
    
    var body: some View {
        if !goals.isEmpty {
            VStack(alignment: .leading, spacing: 10) {
                Text("Active Goals")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.primary)
                
                ForEach(goals) { goal in
                    ActiveGoalRow(goal: goal)
                }
            }
            .padding()
            .background(Color(.secondarySystemGroupedBackground))
            .cornerRadius(15)
        }
    }
}

struct ActiveGoalRow: View {
    let goal: Goal
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(goal.title)
                .font(.headline)
                .foregroundColor(.primary)
            
            Text("\(goal.target) \(goal.type.rawValue)")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            ProgressBar(progress: goal.manualProgress ?? 0)
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
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(15)
    }
}

struct RecentWorkoutsSection: View {
    @ObservedObject var viewModel: WorkoutViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Recent Workouts")
                .font(.title2)
                .bold()
                .foregroundColor(.primary)
            
            ForEach(viewModel.recentWorkouts) { workout in
                WorkoutRow(workout: workout)
                    .padding(.vertical, 4)
            }
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(15)
    }
}