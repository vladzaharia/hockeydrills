//
//  ControlsView.swift
//  HockeyDrills Watch App
//
//  Created by Vlad Zaharia on 1/12/24.
//

import SwiftUI

struct ControlsView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    @EnvironmentObject var drillManager: DrillManager
    
    var body: some View {
        VStack {
            Spacer()
            
            HStack {
                VStack {
                    Button {
                        workoutManager.endWorkout()
                    } label: {
                        Image(systemName: "xmark")
                    }
                    .tint(Color.red)
                    .font(.title2)
                    Text("End")
                }
                
                VStack {
                    Button {
                        workoutManager.togglePause()
                    } label: {
                        Image(systemName: workoutManager.running ? "pause" : "play")
                    }
                    .tint(workoutManager.running ? Color.yellow : Color.green)
                    .font(.title2)
                    Text(workoutManager.running ? "Pause" : "Resume")
                }
            }
            
            Spacer(minLength: 10)
            
            if (drillManager.isDrillWorkout) {
                HStack {
                    VStack {
                        Button {
                            drillManager.resetSteps()
                        } label: {
                            Image(systemName: "arrow.uturn.backward")
                        }
                        .tint(Color.blue)
                        .font(.title2)
                        Text("Restart drills")
                    }
                    .frame(width: 100)
                }

            }
        }
    }
}

#Preview {
    ControlsView()
        .environmentObject(DrillManager())
        .environmentObject(WorkoutManager())
}
