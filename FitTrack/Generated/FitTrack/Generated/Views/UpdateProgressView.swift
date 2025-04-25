import SwiftUI

struct UpdateProgressView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: WorkoutViewModel
    let goal: Goal
    let onDismiss: () -> Void
    
    @State private var progress: Double
    
    init(viewModel: WorkoutViewModel, goal: Goal, onDismiss: @escaping () -> Void) {
        self.viewModel = viewModel
        self.goal = goal
        self.onDismiss = onDismiss
        _progress = State(initialValue: viewModel.calculateGoalProgress(goal))
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Goal Progress")) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text(goal.title)
                            .font(.headline)
                        
                        Text("Target: \(goal.target) \(goal.type.rawValue)")
                            .foregroundColor(.secondary)
                        
                        Slider(value: $progress, in: 0...1, step: 0.01)
                        
                        Text("Progress: \(Int(progress * 100))%")
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 8)
                }
                
                if progress >= 1.0 {
                    Section {
                        Text("Congratulations! 🎉")
                            .font(.headline)
                            .foregroundColor(.green)
                        Text("You've completed this goal!")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Update Progress")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                        onDismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        viewModel.updateGoalProgress(goal, progress: progress)
                        dismiss()
                        onDismiss()
                    }
                }
            }
        }
    }
}