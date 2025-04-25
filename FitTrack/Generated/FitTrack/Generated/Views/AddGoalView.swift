import SwiftUI

struct AddGoalView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: WorkoutViewModel
    
    @State private var goalTitle = ""
    @State private var goalType: GoalType = .workouts
    @State private var targetString = ""
    @State private var deadline = Date().addingTimeInterval(7 * 24 * 3600)
    
    var target: Int {
        return Int(targetString) ?? 0
    }
    
    var isValidInput: Bool {
        !goalTitle.isEmpty && target > 0
    }
    
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
                    
                    TextField("Target Value", text: $targetString)
                        .keyboardType(.numberPad)
                    
                    if !targetString.isEmpty && target <= 0 {
                        Text("Target value must be greater than 0")
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                    
                    DatePicker("Deadline", selection: $deadline, displayedComponents: .date)
                }
                
                Section {
                    Text("Set a realistic target based on your goal type:")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    switch goalType {
                    case .workouts:
                        Text("Suggested: 3-5 workouts per week")
                    case .minutes:
                        Text("Suggested: 150 minutes per week")
                    case .calories:
                        Text("Suggested: 2000-3000 calories per week")
                    }
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
                    .disabled(!isValidInput)
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