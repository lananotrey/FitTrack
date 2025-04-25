import SwiftUI

struct GoalRow: View {
    let goal: Goal
    let progress: Double
    let daysRemaining: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(goal.title)
                    .font(.headline)
                Spacer()
                Text("\(daysRemaining) days left")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            HStack {
                Text("\(Int(progress * 100))%")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text("\(goal.target) \(goal.type.rawValue)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            ProgressBar(progress: progress)
        }
        .padding(.vertical, 4)
    }
}