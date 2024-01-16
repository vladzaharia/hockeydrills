//
//  MetricsView.swift
//  HockeyDrills Watch App
//
//  Created by Vlad Zaharia on 1/12/24.
//

import SwiftUI

struct MetricsView: View {
    @EnvironmentObject var drillManager: DrillManager
    @EnvironmentObject var workoutManager: WorkoutManager
    @EnvironmentObject var settingsManager: SettingsManager
    
    var body: some View {
        TimelineView(
            MetricsTimelineSchedule(
                from: workoutManager.builder?.startDate ?? Date()
            )
        ) { context in
            VStack(alignment: .center) {
                ElapsedTimeView(
                    elapsedTime: workoutManager.builder?.elapsedTime ?? 0,
                    showSubseconds: context.cadence == .live
                )
                    .foregroundStyle(Color.blue.gradient)
                    .fontWeight(.medium)
                
                Divider()
                    .frame(maxWidth: 175)
                    .overlay(Color.white.gradient)
                
                if drillManager.isDrillWorkout {
                    HStack {
                        Text(
                            drillManager.numberCompleted.formatted(.number.precision(.fractionLength(0)))
                        )
                        .fontWeight(.medium)
                        .foregroundStyle(Color.green.gradient)
                        Text("drills").foregroundStyle(Color.white.gradient)
                    }
                }
                
                HStack {
                    Text(
                        Measurement(
                            value: workoutManager.activeEnergy,
                            unit: UnitEnergy.kilocalories
                        ).value.formatted(
                            .number.precision(.fractionLength(0))
                        )
                    )
                    .fontWeight(.medium)
                    .foregroundStyle(Color.orange.gradient)
                    
                    Text("cal").foregroundStyle(Color.white.gradient)
                }
                
                HStack {
                    Text(
                        workoutManager.heartRate.formatted(.number.precision(.fractionLength(0)))
                    )
                    .foregroundStyle(Color.red.gradient)
                    .fontWeight(.medium)
                    
                    Text("bpm").foregroundStyle(Color.white.gradient)
                }
            }
            .font(.system(.title, design: .rounded)
                .monospacedDigit()
                .lowercaseSmallCaps()
            )
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        }
    }
}

private struct MetricsTimelineSchedule: TimelineSchedule {
    var startDate: Date

    init(from startDate: Date) {
        self.startDate = startDate
    }

    func entries(from startDate: Date, mode: TimelineScheduleMode) -> PeriodicTimelineSchedule.Entries {
        PeriodicTimelineSchedule(
            from: self.startDate,
            by: (mode == .lowFrequency ? 1.0 : 1.0 / 30.0)
        ).entries(
            from: startDate,
            mode: mode
        )
    }
}

#Preview {
    MetricsView()
        .environmentObject(DrillManager())
        .environmentObject(WorkoutManager())
        .environmentObject(SettingsManager())
}
