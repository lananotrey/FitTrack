import SwiftUI

struct WorkoutListView: View {
    @ObservedObject var viewModel: WorkoutViewModel
    @State private var showingAddWorkout = false
    @State private var searchText = ""
    
    var filteredWorkouts: [Workout] {
        if searchText.isEmpty {
            return viewModel.workouts
        } else {
            return viewModel.workouts.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(filteredWorkouts) { workout in
                    NavigationLink(destination: WorkoutDetailView(workout: workout)) {
                        WorkoutRow(workout: workout)
                    }
                }
                .onDelete(perform: deleteWorkout)
            }
            .navigationTitle("Workouts")
            .searchable(text: $searchText)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddWorkout = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddWorkout) {
                AddWorkoutView(viewModel: viewModel)
            }
        }
    }
    
    private func deleteWorkout(at offsets: IndexSet) {
        viewModel.deleteWorkouts(at: offsets)
    }
}

struct WorkoutRow: View {
    let workout: Workout
    
    var body: some View {
        HStack {
            Image(systemName: workout.type.icon)
                .font(.title2)
                .foregroundColor(.purple)
                .frame(width: 40, height: 40)
                .background(Color.purple.opacity(0.2))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(workout.name)
                    .font(.headline)
                
                Text("\(workout.duration) min • \(workout.type.rawValue)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text(workout.date.formatted(date: .abbreviated, time: .omitted))
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 8)
    }
}