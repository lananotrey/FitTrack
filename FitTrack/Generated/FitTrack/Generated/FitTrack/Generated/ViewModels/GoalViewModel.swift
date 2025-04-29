import Foundation

class GoalViewModel: ObservableObject {
    @Published var goals: [Goal] = [] {
        didSet {
            saveGoals()
        }
    }
    
    init() {
        loadGoals()
    }
    
    private func saveGoals() {
        if let encodedData = try? JSONEncoder().encode(goals) {
            UserDefaults.standard.set(encodedData, forKey: "goals")
        }
    }
    
    private func loadGoals() {
        if let savedData = UserDefaults.standard.data(forKey: "goals"),
           let decodedGoals = try? JSONDecoder().decode([Goal].self, from: savedData) {
            goals = decodedGoals
        }
    }
    
    func addGoal(_ goal: Goal) {
        goals.append(goal)
    }
    
    func updateGoal(_ goal: Goal) {
        if let index = goals.firstIndex(where: { $0.id == goal.id }) {
            goals[index] = goal
        }
    }
    
    func deleteGoal(_ goal: Goal) {
        goals.removeAll { $0.id == goal.id }
    }
    
    func deleteGoals(at offsets: IndexSet) {
        goals.remove(atOffsets: offsets)
    }
}