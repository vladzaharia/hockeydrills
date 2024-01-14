//
//  HockeyDrillsApp.swift
//  HockeyDrills Watch App
//
//  Created by Vlad Zaharia on 1/11/24.
//

import SwiftUI

@main
struct HockeyDrills_Watch_AppApp: App {
    @StateObject var workoutManager = WorkoutManager.shared
    @State var drillManager = DrillManager.shared
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                StartView().onAppear { workoutManager.requestAuthorization() }
            }
            .sheet(isPresented: $workoutManager.showingSummaryView) {
                SummaryView()
            }
            .environmentObject(workoutManager)
            .environment(drillManager)
        }
    }
}
