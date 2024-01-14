//
//  DrillsView.swift
//  HockeyDrills Watch App
//
//  Created by Vlad Zaharia on 1/12/24.
//

import SwiftUI
import HealthKit

struct DrillsListView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    @Environment(DrillManager.self) var drillManager: DrillManager
        
    var body: some View {
        if drillManager.drillGroups.isEmpty {
            VStack {
                Image(systemName: "hourglass")
                    .font(.system(.title, design: .rounded))
                    .foregroundStyle(Color.blue.gradient)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0))
                
                Text("Loading drills...")
            }.onAppear {
                drillManager.fetchDrills()
            }
        } else {
            List {
                if (drillManager.defaultDrill != nil) {
                    Section(footer: Text("This drill will be started when first pressing the Action button.")) {
                        getButton(drill: drillManager.defaultDrill!, color: Color.blue)
                    }
                }
                
                ForEach(drillManager.drillGroups) { drillGroup in
                    Section(header: Text(drillGroup.name)) {
                        ForEach(drillGroup.drills) { drill in
                            getButton(drill: drill)
                        }
                    }
                }
            }
            .listStyle(.carousel)
            .navigationTitle("Drills")
            .navigationBarTitleDisplayMode(.large)
            .navigationDestination(isPresented: $workoutManager.hasActiveWorkout) {
                SessionPagingView()
            }
        }
    }
    
    func getButton(drill: Drill, color: Color = Color.primary) -> some View {
        return Button {
            drillManager.startDrill(drill: drill)
            workoutManager.startWorkout(workoutType: .skatingSports)
        } label: {
            Label(drill.name, systemImage: drill.icon ?? "checklist")
        }
        .foregroundStyle(color.gradient)
        .padding(
            EdgeInsets(top: 15, leading: 5, bottom: 15, trailing: 5)
        )
    }
}

#Preview {
    DrillsListView()
    .environmentObject(WorkoutManager())
    .environment(DrillManager())
}
