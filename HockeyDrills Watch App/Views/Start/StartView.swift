//
//  ContentView.swift
//  HockeyDrills Watch App
//
//  Created by Vlad Zaharia on 1/11/24.
//

import SwiftUI
import HealthKit

struct StartView: View {
    @EnvironmentObject var drillManager: DrillManager
    @State private var selection: Tab = .drills
    
    enum Tab {
        case drills, workouts, settings
    }
    
    var body: some View {
        TabView(selection: $selection) {
            DrillsListView().tag(Tab.drills)
            WorkoutsListView().tag(Tab.workouts)
            SettingsView().tag(Tab.settings)
        }
    }
}

#Preview {
    StartView()
        .environmentObject(WorkoutManager())
        .environmentObject(DrillManager())
        .environmentObject(SettingsManager())
}
