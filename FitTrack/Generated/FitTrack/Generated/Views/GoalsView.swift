import SwiftUI

struct GoalsView: View {
    @ObservedObject var viewModel: WorkoutViewModel
    @State private var showingAddGoal = false
    @State private var sortOption: GoalSortOption = .deadline
    @State private var filterOption: GoalFilterOption = .all
    
    var filteredAndSortedGoals: [Goal] {
        let filtered = viewModel.goals.filter { goal in
            switch filterOption {
            case .all: return true
            case .active: return !viewModel.isGoalCompleted(goal)
            case .completed: return viewModel.isGoalCompleted(goal)
            }
        }
        
        return filtered.sorted { goal1, goal2 in
            switch sortOption {
            case .deadline:
                return goal1.deadline < goal2.deadline
            case .progress:
                return viewModel.calculateGoalProgress(goal1) > viewModel.calculateGoalProgress(goal2)
            case .name:
                return goal1.title < goal2.title
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                filterAndSortHeader
                
                List {
                    ForEach(filteredAndSortedGoals) { goal in
                        GoalRow(goal: goal, 
                               progress: viewModel.calculateGoalProgress(goal),
                               daysRemaining: viewModel.daysRemaining(for: goal),
                               onProgressTap: { viewModel.toggleGoalCompletion(goal) })
                    }
                    .onDelete(perform: deleteGoal)
                }
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
    
    private var filterAndSortHeader: some View {
        VStack(spacing: 8) {
            Picker("Filter", selection: $filterOption) {
                ForEach(GoalFilterOption.allCases, id: \.self) { option in
                    Text(option.rawValue).tag(option)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            
            Picker("Sort by", selection: $sortOption) {
                ForEach(GoalSortOption.allCases, id: \.self) { option in
                    Text(option.rawValue).tag(option)
                }
            }
            .pickerStyle(.menu)
        }
        .padding(.vertical, 8)
        .background(Color(.systemBackground))
    }
    
    private func deleteGoal(at offsets: IndexSet) {
        viewModel.deleteGoals(at: offsets)
    }
}

struct GoalRow: View {
    let goal: Goal
    let progress: Double
    let daysRemaining: Int
    let onProgressTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(goal.title)
                    .font(.headline)
                Spacer()
                Button(action: onProgressTap) {
                    Text("\(Int(progress * 100))%")
                        .foregroundColor(.purple)
                        .bold()
                }
            }
            
            ProgressBar(progress: progress)
            
            HStack {
                Text(goal.type.rawValue)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                HStack(spacing: 4) {
                    Image(systemName: "calendar")
                        .foregroundColor(.secondary)
                    Text(daysRemaining == 0 ? "Due today" :
                            daysRemaining < 0 ? "Overdue" :
                            "\(daysRemaining) days left")
                        .font(.subheadline)
                        .foregroundColor(daysRemaining <= 0 ? .red : .secondary)
                }
                
                Text("Target: \(goal.target)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 8)
        .contentShape(Rectangle())
        .onTapGesture {
            onProgressTap()
        }
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

enum GoalSortOption: String, CaseIterable {
    case deadline = "Deadline"
    case progress = "Progress"
    case name = "Name"
}

enum GoalFilterOption: String, CaseIterable {
    case all = "All"
    case active = "Active"
    case completed = "Completed"
}