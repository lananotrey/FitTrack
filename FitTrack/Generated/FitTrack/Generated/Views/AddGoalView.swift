import SwiftUI

struct AddGoalView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: WorkoutViewModel
    
    @State private var goalTitle = ""
    @State private var goalType: GoalType = .workouts
    @State private var target = 10
    @State private var deadline = Date().addingTimeInterval(7 * 24 * 3600)
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Goal Details")) {
                    TextField("Goal Title", text: $goalTitle)
                    
                    Picker("Type", selection: $goalType) {
                        ForEach(GoalType.allCases, id: \.self) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                    
                    Stepper(value: $target, in: 1...1000) {
                        Text("Target: \(target)")
                    }
                    
                    DatePicker("Deadline", selection: $deadline, displayedComponents: .date)
                }
            }
            .navigationTitle("Add Goal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveGoal()
                    }
                    .disabled(goalTitle.isEmpty)
                }
            }
        }
    }
    
    private func saveGoal() {
        let goal = Goal(
            title: goalTitle,
            type: goalType,
            target: target,
            deadline: deadline
        )
        viewModel.addGoal(goal)
        dismiss()
    }
}