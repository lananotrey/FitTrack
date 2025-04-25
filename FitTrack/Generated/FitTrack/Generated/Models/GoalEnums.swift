import Foundation

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