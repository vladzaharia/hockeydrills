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
    @EnvironmentObject var drillManager: DrillManager
    @EnvironmentObject var workoutManager: WorkoutManager
    
    @State private var durationFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = .pad
        return formatter
    }()
    
    var body: some View {
        if workoutManager.workout == nil {
            VStack {
                Image(systemName: "icloud.and.arrow.up.fill")
                    .font(.system(.title, design: .rounded))
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0))
                
                Text("Saving workout...")
                    .font(.system(.title3, design: .rounded))
                    .multilineTextAlignment(.center)
                    .fontWeight(.semibold)
            }
            .edgesIgnoringSafeArea(.all)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            .background(Color.blue.gradient)
            .foregroundStyle(Color.black.gradient)
            .navigationBarHidden(true)
        } else {
            ScrollView(.vertical) {
                VStack(alignment: .leading) {
                    WorkoutTypeView(workout: workoutManager.selectedWorkout, drill: drillManager.selectedDrill)
                    
                    SummaryMetricView(
                        title: "Total Time",
                        value: durationFormatter.string(from: workoutManager.workout?.duration ?? 0.0) ?? "",
                        color: Color.blue
                    )
                    
                    if (drillManager.isDrillWorkout) {
                        SummaryMetricView(
                            title: "Drills Completed",
                            value: drillManager.numberCompleted
                                .formatted(
                                    .number.precision(.fractionLength(0))
                                ),
                            color: Color.green
                        )
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
                        ),
                        color: Color.pink
                    )
                    
                    SummaryMetricView(
                        title: "Avg. Heart Rate",
                        value: workoutManager.averageHeartRate
                            .formatted(
                                .number.precision(.fractionLength(0))
                            )
                        + " bpm",
                        color: Color.red
                    )
                    
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

struct WorkoutTypeView: View {
    var workout: HKWorkoutActivityType?
    var drill: Drill?
    
    var body: some View {
        Text("Workout Type")
        
        Text((drill != nil ? drill?.name : workout?.name) ?? "N/A")
            .font(.system(.title3, design: .rounded))
            .padding(EdgeInsets(top: 2, leading: 0, bottom: drill != nil ? 0 : 2, trailing: 0))
            .foregroundStyle(Color.primary.gradient)
        
        if (drill != nil) {
            Text("(Ice Skating)")
                .foregroundStyle(Color.secondary)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 2, trailing: 0))
        }
        
        Divider()
        Spacer(minLength: 10)
    }
}

struct SummaryMetricView: View {
    var title: String
    var value: String
    var color: Color
    
    var body: some View {
        Text(title)
        Text(value)
            .font(.system(.title2, design: .rounded)
                .lowercaseSmallCaps())
            .foregroundStyle(color.gradient)
        
        Divider()
        Spacer(minLength: 10)
    }
}

#Preview {
    SummaryView()
        .environmentObject(DrillManager())
        .environmentObject(WorkoutManager())
}
