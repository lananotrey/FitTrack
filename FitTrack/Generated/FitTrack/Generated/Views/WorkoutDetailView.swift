import SwiftUI

struct WorkoutDetailView: View {
    let workout: Workout
    
    var body: some View {
        List {
            Section(header: Text("Details")) {
                DetailRow(title: "Type", value: workout.type.rawValue)
                DetailRow(title: "Duration", value: "\(workout.duration) minutes")
                DetailRow(title: "Date", value: workout.date.formatted(date: .long, time: .shortened))
            }
            
            if let notes = workout.notes {
                Section(header: Text("Notes")) {
                    Text(notes)
                        .foregroundColor(.secondary)
                }
            }
        }
        .navigationTitle(workout.name)
    }
}

struct DetailRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.medium)
        }
    }
}