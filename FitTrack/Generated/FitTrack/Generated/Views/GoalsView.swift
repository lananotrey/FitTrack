import SwiftUI

struct GoalsView: View {
    @ObservedObject var viewModel: WorkoutViewModel
    @State private var showingAddGoal = false
    @State private var sortOption: GoalSortOption = .deadline
    @State private var filterOption: GoalFilterOption = .all
    @State private var selectedGoal: Goal?
    @State private var showingProgressSheet = false
    
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
                               daysRemaining: viewModel.daysRemaining(for: goal))
                        .onTapGesture {
                            selectedGoal = goal
                            showingProgressSheet = true
                        }
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
            .sheet(isPresented: $showingProgressSheet) {
                if let goal = selectedGoal {
                    UpdateProgressView(viewModel: viewModel, goal: goal) {
                        showingProgressSheet = false
                    }
                }
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
    }
}

struct UpdateProgressView: View {
    @ObservedObject var viewModel: WorkoutViewModel
    let goal: Goal
    let dismissAction: () -> Void
    @State private var progress: Double
    
    init(viewModel: WorkoutViewModel, goal: Goal, dismissAction: @escaping () -> Void) {
        self.viewModel = viewModel
        self.goal = goal
        self.dismissAction = dismissAction
        _progress = State(initialValue: (goal.manualProgress ?? viewModel.calculateGoalProgress(goal)) * 100)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Update Progress")) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Goal: \(goal.title)")
                            .font(.headline)
                        
                        Text("Target: \(goal.target) \(goal.type.rawValue)")
                            .foregroundColor(.secondary)
                        
                        Slider(value: $progress, in: 0...100, step: 1) {
                            Text("Progress")
                        }
                        
                        Text("Progress: \(Int(progress))%")
                            .foregroundColor(.purple)
                            .bold()
                    }
                }
                
                Section {
                    Button("Mark as Complete") {
                        viewModel.updateGoalProgress(goal, progress: 1.0)
                        dismissAction()
                    }
                    .foregroundColor(.green)
                    
                    if progress < 100 {
                        Button("Update Progress") {
                            viewModel.updateGoalProgress(goal, progress: progress / 100)
                            dismissAction()
                        }
                        .foregroundColor(.purple)
                    }
                }
            }
            .navigationTitle("Update Progress")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", action: dismissAction)
                }
            }
        }
    }
}