import Foundation

class WorkoutViewModel: ObservableObject {
    @Published var workouts: [Workout] = []
    @Published var goals: [Goal] = []
    
    var recentWorkouts: [Workout] {
        Array(workouts.prefix(5))
    }
    
    var workoutsThisWeek: Int {
        let calendar = Calendar.current
        let oneWeekAgo = calendar.date(byAdding: .day, value: -7, to: Date())!
        return workouts.filter { $0.date >= oneWeekAgo }.count
    }
    
    var currentStreak: Int {