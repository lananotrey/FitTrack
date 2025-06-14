import Foundation

struct Workout: Identifiable, Codable {
    let id: UUID
    let name: String
    let type: WorkoutType
    let duration: Int
    let date: Date
    let notes: String?
    
    init(id: UUID = UUID(), name: String, type: WorkoutType, duration: Int, date: Date, notes: String? = nil) {
        self.id = id
        self.name = name
        self.type = type
        self.duration = duration
        self.date = date
        self.notes = notes
    }
}

enum WorkoutType: String, CaseIterable, Codable {
    case cardio = "Cardio"
    case strength = "Strength"
    case flexibility = "Flexibility"
    case hiit = "HIIT"
    case yoga = "Yoga"
    
    var icon: String {
        switch self {
        case .cardio: return "heart.fill"
        case .strength: return "dumbbell.fill"
        case .flexibility: return "figure.walk"
        case .hiit: return "bolt.fill"
        case .yoga: return "figure.mind.and.body"
        }
    }
}

enum TimeFrame: String, CaseIterable {
    case week = "Week"
    case month = "Month"
    case year = "Year"
}