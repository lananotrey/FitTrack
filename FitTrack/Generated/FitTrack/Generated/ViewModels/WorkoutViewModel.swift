import Foundation

class WorkoutViewModel: ObservableObject {
    @Published var workouts: [Workout] = [] {
        didSet {
            saveData()
        }
    }
    
    @Published var goals: [Goal] = [] {
        didSet {
            saveData()
        }
    }
    
    init() {
        loadData()
    }
    
    private func saveData() {
        do {
            let workoutsData = try JSONEncoder().encode(workouts)
            let goalsData = try JSONEncoder().encode(goals)
            
            if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let workoutsURL = documentsDirectory.appendingPathComponent("workouts.json")
                let goalsURL = documentsDirectory.appendingPathComponent("goals.json")
                
                try workoutsData.write(to: workoutsURL)
                try goalsData.write(to: goalsURL)
            }
        } catch {
            print("Error saving data: \(error)")
        }
    }
    
    private func loadData() {
        do {
            if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let workoutsURL = documentsDirectory.appendingPathComponent("workouts.json")
                let goalsURL = documentsDirectory.appendingPathComponent("goals.json")
                
                if let workoutsData = try? Data(contentsOf: workoutsURL) {
                    workouts = try JSONDecoder().decode([Workout].self, from: workoutsData)
                }
                
                if let goalsData = try? Data(contentsOf: goalsURL) {
                    goals = try JSONDecoder().decode([Goal].self, from: goalsData)
                }
            }
        } catch {
            print("Error loading data: \(error)")
        }
    }
    
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
        updateGoalsProgress()
        saveData()
    }
    
    func updateWorkout(_ workout: Workout) {
        if let index = workouts.firstIndex(where: { $0.id == workout.id }) {
            workouts[index] = workout
            workouts.sort { $0.date > $1.date }
            updateGoalsProgress()
            saveData()
        }
    }
    
    func deleteWorkouts(at offsets: IndexSet) {
        workouts.remove(atOffsets: offsets)
        updateGoalsProgress()
        saveData()
    }
    
    func deleteWorkout(_ workout: Workout) {
        if let index = workouts.firstIndex(where: { $0.id == workout.id }) {
            workouts.remove(at: index)
            updateGoalsProgress()
            saveData()
        }
    }
    
    func addGoal(_ goal: Goal) {
        var newGoal = goal
        newGoal.manualProgress = 0.0
        goals.append(newGoal)
        saveData()
    }
    
    func deleteGoals(at offsets: IndexSet) {
        goals.remove(atOffsets: offsets)
        saveData()
    }
    
    func deleteGoal(_ goal: Goal) {
        if let index = goals.firstIndex(where: { $0.id == goal.id }) {
            goals.remove(at: index)
            saveData()
        }
    }
    
    private func updateGoalsProgress() {
        for (index, goal) in goals.enumerated() {
            let progress = calculateGoalProgress(goal)
            goals[index].manualProgress = progress
            goals[index].isCompleted = progress >= 1.0
        }
        objectWillChange.send()
        saveData()
    }
    
    func calculateGoalProgress(_ goal: Goal) -> Double {
        if goal.isCompleted {
            return 1.0
        }
        
        if let manualProgress = goal.manualProgress {
            return manualProgress
        }
        
        let relevantWorkouts = workouts.filter { $0.date <= goal.deadline }
        
        switch goal.type {
        case .workouts:
            let completedWorkouts = Double(relevantWorkouts.count)
            return min(completedWorkouts / Double(goal.target), 1.0)
            
        case .minutes:
            let totalMinutes = Double(relevantWorkouts.reduce(0) { $0 + $1.duration })
            return min(totalMinutes / Double(goal.target), 1.0)
            
        case .calories:
            let caloriesPerMinute = 5
            let totalCalories = Double(relevantWorkouts.reduce(0) { $0 + ($1.duration * caloriesPerMinute) })
            return min(totalCalories / Double(goal.target), 1.0)
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
        saveData()
    }
}