import SwiftUI

struct AddWorkoutView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: WorkoutViewModel
    
    @State private var workoutName = ""
    @State private var workoutType: WorkoutType = .cardio
    @State private var durationString = ""
    @State private var date = Date()
    @State private var notes = ""
    
    var duration: Int {
        return Int(durationString) ?? 0
    }
    
    var isValidInput: Bool {
        !workoutName.isEmpty && duration > 0 && duration <= 180
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Workout Details")) {
                    TextField("Workout Name", text: $workoutName)
                    
                    Picker("Type", selection: $workoutType) {
                        ForEach(WorkoutType.allCases, id: \.self) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                    
                    TextField("Duration (minutes)", text: $durationString)
                        .keyboardType(.numberPad)
                    
                    if !durationString.isEmpty && (duration <= 0 || duration > 180) {
                        Text("Duration must be between 1 and 180 minutes")
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                    
                    DatePicker("Date", selection: $date, displayedComponents: [.date, .hourAndMinute])
                }
                
                Section(header: Text("Notes")) {
                    TextEditor(text: $notes)
                        .frame(height: 100)
                }
            }
            .navigationTitle("Add Workout")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveWorkout()
                    }
                    .disabled(!isValidInput)
                }
            }
        }
    }
    
    private func saveWorkout() {
        let workout = Workout(
            name: workoutName,
            type: workoutType,
            duration: duration,
            date: date,
            notes: notes.isEmpty ? nil : notes
        )
        viewModel.addWorkout(workout)
        dismiss()
    }
}