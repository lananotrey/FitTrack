import SwiftUI

struct WorkoutListView: View {
    @ObservedObject var viewModel: WorkoutViewModel
    @Binding var selectedTab: Int
    @State private var showingAddWorkout = false
    @State private var showingEditWorkout = false
    @State private var selectedWorkout: Workout?
    @State private var searchText = ""
    @State private var showingDeleteAlert = false
    @State private var workoutToDelete: Workout?
    @State private var showingSuccessMessage = false
    @State private var successMessage = ""
    
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
                    WorkoutRow(workout: workout)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedWorkout = workout
                            showingEditWorkout = true
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            Button(role: .destructive) {
                                workoutToDelete = workout
                                showingDeleteAlert = true
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                            
                            Button {
                                selectedWorkout = workout
                                showingEditWorkout = true
                            } label: {
                                Label("Edit", systemImage: "pencil")
                            }
                            .tint(.blue)
                        }
                }
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
                AddWorkoutView(viewModel: viewModel, selectedTab: $selectedTab)
            }
            .sheet(item: $selectedWorkout) { workout in
                EditWorkoutView(viewModel: viewModel, workout: workout)
                    .onDisappear {
                        successMessage = "Workout updated successfully!"
                        showingSuccessMessage = true
                    }
            }
            .alert("Delete Workout", isPresented: $showingDeleteAlert, presenting: workoutToDelete) { workout in
                Button("Delete", role: .destructive) {
                    withAnimation {
                        viewModel.deleteWorkout(workout)
                        successMessage = "Workout deleted successfully!"
                        showingSuccessMessage = true
                    }
                }
                Button("Cancel", role: .cancel) {}
            } message: { workout in
                Text("Are you sure you want to delete '\(workout.name)'?")
            }
            .overlay(
                ToastView(message: successMessage, isShowing: $showingSuccessMessage)
                    .animation(.easeInOut, value: showingSuccessMessage)
            )
        }
    }
}

struct ToastView: View {
    let message: String
    @Binding var isShowing: Bool
    
    var body: some View {
        if isShowing {
            VStack {
                Spacer()
                Text(message)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(10)
                    .padding(.bottom, 20)
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        isShowing = false
                    }
                }
            }
        }
    }
}