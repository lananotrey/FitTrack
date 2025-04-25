import Foundation

class WorkoutViewModel: ObservableObject {
    @Published var workouts: [Workout] = []
    @Published var goals: [Goal] = []
    
    var recentWorkouts: [Workout] {
        Array(workouts.prefix(5))
    }
    
    var activeGoals: [Goal] {
        goals.filter { !$0.isCompleted }
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
    
    func deleteWorkout(_ workout: Workout) {
        if let index = workouts.firstIndex(where: { $0.id == workout.id }) {
            workouts.remove(at: index)
        }
    }
    
    func addGoal(_ goal: Goal) {
        goals.append(goal)
    }
    
    func deleteGoals(at offsets: IndexSet) {
        goals.remove(atOffsets: offsets)
    }
    
    func deleteGoal(_ goal: Goal) {
        if let index = goals.firstIndex(where: { $0.id == goal.id }) {
            goals.remove(at: index)
        }
    }
    
    func calculateGoalProgress(_ goal: Goal) -> Double {
        if goal.isCompleted {
            return 1.0
        }
        
        if let manualProgress = goal.manualProgress {
            return manualProgress
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
        return goal.isCompleted
    }
    
    func updateGoalProgress(_ goal: Goal, progress: Double) {
        if let index = goals.firstIndex(where: { $0.id == goal.id }) {
            goals[index] = Goal(
                id: goal.id,
                title: goal.title,
                type: goal.type,
                target: goal.target,
                deadline: goal.deadline,
                manualProgress: progress,
                isCompleted: progress >= 1.0
            )
        }
        objectWillChange.send()
    }
}