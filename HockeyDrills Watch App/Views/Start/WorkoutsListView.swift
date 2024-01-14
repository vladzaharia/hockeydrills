//
//  WorkoutsListView.swift
//  HockeyDrills Watch App
//
//  Created by Vlad Zaharia on 1/12/24.
//

import SwiftUI
import HealthKit

struct WorkoutsListView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    @EnvironmentObject var drillManager: DrillManager
    
    var workouts: [HKWorkoutActivityType] = [.hockey, .skatingSports, .other]
    
    var body: some View {
        List(workouts) { workout in
            Button {
                drillManager.endDrill() // just in case
                workoutManager.startWorkout(workoutType: workout)
            } label: {
                Label(workout.name, systemImage: workout.icon)
            }
            .padding(
                EdgeInsets(top: 15, leading: 5, bottom: 15, trailing: 5)
            )
        }
        .listStyle(.carousel)
        .navigationTitle("Workouts")
        .navigationBarTitleDisplayMode(.large)
        .navigationDestination(isPresented: $workoutManager.hasActiveWorkout) {
            SessionPagingView()
        }
    }
}

extension HKWorkoutActivityType: Identifiable {
    public var id: UInt {
        rawValue
    }
    
    var name: String {
        switch self {
        case .hockey:
            return "Hockey"
        case .skatingSports:
            return "Ice Skating"
        default:
            return "Other"
        }
    }
}

extension HKWorkoutActivityType {
    var icon: String {
        switch self {
        case .hockey:
            return "hockey.puck"
        case .skatingSports:
            return "figure.hockey"
        default:
            return "sportscourt.circle"
        }
    }
}

#Preview {
    WorkoutsListView()
        .environmentObject(WorkoutManager())
        .environmentObject(DrillManager())
}
