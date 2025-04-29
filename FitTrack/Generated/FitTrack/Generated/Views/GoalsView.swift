import SwiftUI

struct GoalsView: View {
    @ObservedObject var workoutViewModel: WorkoutViewModel
    @State private var showingAddGoal = false
    @State private var sortOption: GoalSortOption = .deadline
    @State private var filterOption: GoalFilterOption = .all
    @State private var selectedGoal: Goal?
    @State private var showingProgressSheet = false
    @State private var showingDeleteAlert = false
    @State private var goalToDelete: Goal?
    
    private var filteredGoals: [Goal] {
        workoutViewModel.goals.filter { goal in
            switch filterOption {
            case .all: return true
            case .active: return !goal.isCompleted
            case .completed: return goal.isCompleted
            }
        }
    }
    
    private var sortedGoals: [Goal] {
        filteredGoals.sorted { goal1, goal2 in
            switch sortOption {
            case .deadline:
                return goal1.deadline < goal2.deadline
            case .progress:
                let progress1 = goal1.manualProgress ?? 0
                let progress2 = goal2.manualProgress ?? 0
                return progress1 > progress2
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
                    ForEach(sortedGoals) { goal in
                        GoalRow(
                            goal: goal,
                            progress: goal.manualProgress ?? 0,
                            daysRemaining: Calendar.current.dateComponents([.day], from: Date(), to: goal.deadline).day ?? 0
                        )
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedGoal = goal
                            showingProgressSheet = true
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                goalToDelete = goal
                                showingDeleteAlert = true
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
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
                AddGoalView(viewModel: workoutViewModel)
            }
            .sheet(item: $selectedGoal) { goal in
                UpdateProgressView(viewModel: workoutViewModel, goal: goal) {
                    selectedGoal = nil
                }
            }
            .alert("Delete Goal", isPresented: $showingDeleteAlert, presenting: goalToDelete) { goal in
                Button("Delete", role: .destructive) {
                    withAnimation {
                        workoutViewModel.deleteGoal(goal)
                    }
                }
                Button("Cancel", role: .cancel) {}
            } message: { goal in
                Text("Are you sure you want to delete '\(goal.title)'?")
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
}