import SwiftUI

struct GoalsView: View {
    @ObservedObject var viewModel: WorkoutViewModel
    @State private var showingAddGoal = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.goals) { goal in
                    GoalRow(goal: goal, progress: viewModel.calculateGoalProgress(goal))
                }
                .onDelete(perform: deleteGoal)
            }
            .navigationTitle("Goals")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddGoal = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddGoal) {
                AddGoalView(viewModel: viewModel)
            }
        }
    }
    
    private func deleteGoal(at offsets: IndexSet) {
        viewModel.deleteGoals(at: offsets)
    }
}

struct GoalRow: View {
    let goal: Goal
    let progress: Double
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(goal.title)
                    .font(.headline)
                Spacer()
                Text("\(Int(progress * 100))%")
                    .foregroundColor(.purple)
                    .bold()
            }
            
            ProgressBar(progress: progress)
            
            HStack {
                Text(goal.type.rawValue)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text("Target: \(goal.target)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 8)
    }
}

struct ProgressBar: View {
    let progress: Double
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .foregroundColor(Color(.systemGray5))
                
                Rectangle()
                    .foregroundColor(.purple)
                    .frame(width: geometry.size.width * progress)
            }
        }
        .frame(height: 8)
        .cornerRadius(4)
    }
}