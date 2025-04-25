import SwiftUI

struct GoalsView: View {
    @ObservedObject var viewModel: WorkoutViewModel
    @State private var showingAddGoal = false
    @State private var sortOption: GoalSortOption = .deadline
    @State private var filterOption: GoalFilterOption = .all
    @State private var selectedGoal: Goal?
    @State private var showingProgressSheet = false
    @State private var showingDeleteAlert = false
    @State private var goalToDelete: Goal?
    
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
                AddGoalView(viewModel: viewModel)
            }
            .sheet(item: $selectedGoal) { goal in
                UpdateProgressView(viewModel: viewModel, goal: goal) {
                    selectedGoal = nil
                }
            }
            .alert("Delete Goal", isPresented: $showingDeleteAlert, presenting: goalToDelete) { goal in
                Button("Delete", role: .destructive) {
                    withAnimation {
                        viewModel.deleteGoal(goal)
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