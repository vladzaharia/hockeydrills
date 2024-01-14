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
        .navigationDestination(isPresented: $workoutManager.hasActiveWorkout) {
            SessionPagingView()
        }
    }
    
    func getButton(drill: Drill, color: Color = Color.primary) -> some View {
        return Button {
            drillManager.startDrill(drill: drill)
            workoutManager.startWorkout(workoutType: .skatingSports)
        } label: {
            Label(drill.name, systemImage: drill.icon)
        }
        .foregroundStyle(color)
        .padding(
            EdgeInsets(top: 15, leading: 5, bottom: 15, trailing: 5)
        )
    }
}

//#Preview {
//    DrillsListView()
//    .environmentObject(WorkoutManager())
//    .environment(DrillManager())
//}

struct DrillsListView_Previews: PreviewProvider {
    static var previews: some View {
        DrillsListView()
        .environmentObject(WorkoutManager())
        .environment(DrillManager())
    }
}
