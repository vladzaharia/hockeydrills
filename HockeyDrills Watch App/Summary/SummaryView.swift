//
//  SummaryView.swift
//  HockeyDrills Watch App
//
//  Created by Vlad Zaharia on 1/12/24.
//

import SwiftUI
import HealthKit

struct SummaryView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(DrillManager.self) var drillManager: DrillManager
    @EnvironmentObject var workoutManager: WorkoutManager
    
    @State private var durationFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = .pad
        return formatter
    }()
    
    var body: some View {
        if workoutManager.workout == nil {
            ProgressView("Saving workout")
                .navigationBarHidden(true)
        } else {
            ScrollView(.vertical) {
                VStack(alignment: .leading) {
                    SummaryMetricView(
                        title: "Total Time",
                        value: durationFormatter.string(from: workoutManager.workout?.duration ?? 0.0) ?? ""
                    ).accentColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                    
                    if (drillManager.isDrillWorkout) {
                        SummaryMetricView(
                            title: "Drills Completed",
                            value: drillManager.numberCompleted
                                .formatted(
                                    .number.precision(.fractionLength(0))
                                )
                        ).accentColor(Color.green)
                    }
                    
                    SummaryMetricView(
                        title: "Total Energy",
                        value: Measurement(
                            value: workoutManager.workout?.totalEnergyBurned?
                                .doubleValue(for: .kilocalorie()) ?? 0,
                            unit: UnitEnergy.kilocalories
                        ).formatted(
                            .measurement(
                                width: .abbreviated,
                                usage: .workout,
                                numberFormatStyle: .number.precision(.fractionLength(0))
                            )
                        )
                    ).accentColor(Color.pink)
                    
                    SummaryMetricView(
                        title: "Avg. Heart Rate",
                        value: workoutManager.averageHeartRate
                            .formatted(
                                .number.precision(.fractionLength(0))
                            )
                        + " bpm"
                    ).accentColor(Color.red)
                    
                    Text("Activity Rings")
                    ActivityRingsView(healthStore: HKHealthStore()).frame(width: 50, height: 50)
                    
                    Spacer(minLength: 15)
                    
                    Button("Done") {
                        if (drillManager.isDrillWorkout) {
                            drillManager.endDrill()
                        }
                        dismiss()
                    }
                }
                .scenePadding()
            }
            .navigationTitle("Summary")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct SummaryMetricView: View {
    var title: String
    var value: String
    
    var body: some View {
        Text(title)
        Text(value)
            .font(.system(.title2, design: .rounded)
                .lowercaseSmallCaps())
            .foregroundColor(.accentColor)
        
        Divider()
        Spacer(minLength: 10)
    }
}

//#Preview {
//    SummaryView()
//}

struct SummaryView_Previews: PreviewProvider {
    static var previews: some View {
        SummaryView()
            .environment(DrillManager())
            .environmentObject(WorkoutManager())
    }
}
