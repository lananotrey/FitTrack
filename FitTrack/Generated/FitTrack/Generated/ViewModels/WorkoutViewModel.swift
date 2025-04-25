import Foundation

class WorkoutViewModel: ObservableObject {
    @Published var workouts: [Workout] = []
    @Published var goals: [Goal] = []
    @Published private var completedGoals: Set<UUID> = []
    
    var recentWorkouts: [Workout] {
        Array(workouts.prefix(5))
    }
    
    var workoutsThisWeek: Int {
        let calendar = Calendar.current
        let oneWeekAgo = calendar.date(byAdding: .day, value: -7, to: Date())!
        return workouts.filter { $0.date >= oneWeekAgo }.count
    }
    
    var currentStreak: Int {
        var streak = 0
        let calendar = Calendar.current
        var currentDate = Date()
        
        while let workout = workouts.first(where: { calendar.isDate($0.date, inSameDayAs: currentDate) }) {
            streak += 1
            currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate)!
        }
        
        return streak
    }
    
    func addWorkout(_ workout: Workout) {
        workouts.append(workout)
        workouts.sort { $0.date > $1.date }
    }
    
    func deleteWorkouts(at offsets: IndexSet) {
        workouts.remove(atOffsets: offsets)
    }
    
    func addGoal(_ goal: Goal) {
        goals.append(goal)
    }
    
    func deleteGoals(at offsets: IndexSet) {
        offsets.forEach { index in
            completedGoals.remove(goals[index].id)
        }
        goals.remove(atOffsets: offsets)
    }
    
    func calculateGoalProgress(_ goal: Goal) -> Double {
        if isGoalCompleted(goal) {
            return 1.0
        }
        
        switch goal.type {
        case .workouts:
            let completedWorkouts = workouts.filter { $0.date <= goal.deadline }.count
            return min(Double(completedWorkouts) / Double(goal.target), 1.0)
            
        case .minutes:
            let totalMinutes = workouts
                .filter { $0.date <= goal.deadline }
                .reduce(0) { $0 + $1.duration }
            return min(Double(totalMinutes) / Double(goal.target), 1.0)
            
        case .calories:
            let caloriesPerMinute = 5
            let totalCalories = workouts
                .filter { $0.date <= goal.deadline }
                .reduce(0) { $0 + ($1.duration * caloriesPerMinute) }
            return min(Double(totalCalories) / Double(goal.target), 1.0)
        }
    }
    
    func daysRemaining(for goal: Goal) -> Int {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let deadline = calendar.startOfDay(for: goal.deadline)
        return calendar.dateComponents([.day], from: today, to: deadline).day ?? 0
    }
    
    func isGoalCompleted(_ goal: Goal) -> Bool {
        completedGoals.contains(goal.id)
    }
    
    func toggleGoalCompletion(_ goal: Goal) {
        if completedGoals.contains(goal.id) {
            completedGoals.remove(goal.id)
        } else {
            completedGoals.insert(goal.id)
        }
        objectWillChange.send()
    }
}