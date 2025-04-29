import Foundation

struct Goal: Identifiable, Codable {
    let id: UUID
    let title: String
    let type: GoalType
    let target: Int
    let deadline: Date
    var manualProgress: Double?
    var isCompleted: Bool
    
    init(id: UUID = UUID(), title: String, type: GoalType, target: Int, deadline: Date, manualProgress: Double? = nil, isCompleted: Bool = false) {
        self.id = id
        self.title = title
        self.type = type
        self.target = target
        self.deadline = deadline
        self.manualProgress = manualProgress
        self.isCompleted = isCompleted
    }
}

enum GoalType: String, CaseIterable, Codable {
    case workouts = "Workouts Completed"
    case minutes = "Minutes Exercised"
    case calories = "Calories Burned"
}