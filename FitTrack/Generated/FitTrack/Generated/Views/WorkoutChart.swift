import SwiftUI
import Charts

struct WorkoutChart: View {
    @ObservedObject var viewModel: WorkoutViewModel
    let timeFrame: TimeFrame
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Workout Activity")
                .font(.title2)
                .bold()
            
            Picker("Time Frame", selection: .constant(timeFrame)) {
                ForEach(TimeFrame.allCases, id: \.self) { frame in
                    Text(frame.rawValue).tag(frame)
                }
            }
            .pickerStyle(.segmented)
            
            ChartView(workouts: viewModel.workouts, timeFrame: timeFrame)
                .frame(height: 200)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 2)
    }
}

struct ChartView: View {
    let workouts: [Workout]
    let timeFrame: TimeFrame
    
    var body: some View {
        Chart {
            ForEach(chartData) { data in
                BarMark(
                    x: .value("Date", data.date),
                    y: .value("Count", data.count)
                )
                .foregroundStyle(Color.purple.gradient)
            }
        }
    }
    
    private var chartData: [WorkoutData] {
        let calendar = Calendar.current
        let now = Date()
        
        let range: Int
        let component: Calendar.Component
        
        switch timeFrame {
        case .week:
            range = 7
            component = .day
        case .month:
            range = 30
            component = .day
        case .year:
            range = 12
            component = .month
        }
        
        return (0..<range).map { offset in
            let date = calendar.date(byAdding: component, value: -offset, to: now)!
            let count = workouts.filter { calendar.isDate($0.date, equalTo: date, toGranularity: component) }.count
            return WorkoutData(date: date, count: count)
        }.reversed()
    }
}

struct WorkoutData: Identifiable {
    let id = UUID()
    let date: Date
    let count: Int
}