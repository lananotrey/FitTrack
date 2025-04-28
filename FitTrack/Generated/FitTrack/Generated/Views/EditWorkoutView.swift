import SwiftUI

struct EditWorkoutView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: WorkoutViewModel
    let workout: Workout
    
    @State private var workoutName: String
    @State private var workoutType: WorkoutType
    @State private var durationString: String
    @State private var date: Date
    @State private var notes: String
    @State private var showingSuccessAlert = false
    
    init(viewModel: WorkoutViewModel, workout: Workout) {
        self.viewModel = viewModel
        self.workout = workout
        _workoutName = State(initialValue: workout.name)
        _workoutType = State(initialValue: workout.type)
        _durationString = State(initialValue: String(workout.duration))
        _date = State(initialValue: workout.date)
        _notes = State(initialValue: workout.notes ?? "")
    }
    
    var duration: Int {
        return Int(durationString) ?? 0
    }
    
    var isValidInput: Bool {
        !workoutName.isEmpty && duration > 0 && duration <= 180
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Workout Details").foregroundColor(.primary)) {
                    TextField("Workout Name", text: $workoutName)
                    
                    HStack {
                        Text("Type")
                        Spacer()
                        Picker("Type", selection: $workoutType) {
                            ForEach(WorkoutType.allCases, id: \.self) { type in
                                Text(type.rawValue).tag(type)
                            }
                        }
                        .pickerStyle(.menu)
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
                
                Section(header: Text("Notes").foregroundColor(.primary)) {
                    TextEditor(text: $notes)
                        .frame(height: 100)
                }
            }
            .navigationTitle("Edit Workout")
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
            .alert("Success", isPresented: $showingSuccessAlert) {
                Button("OK") {
                    dismiss()
                }
            } message: {
                Text("Workout updated successfully!")
            }
        }
    }
    
    private func saveWorkout() {
        let updatedWorkout = Workout(
            id: workout.id,
            name: workoutName,
            type: workoutType,
            duration: duration,
            date: date,
            notes: notes.isEmpty ? nil : notes
        )
        viewModel.updateWorkout(updatedWorkout)
        showingSuccessAlert = true
    }
}