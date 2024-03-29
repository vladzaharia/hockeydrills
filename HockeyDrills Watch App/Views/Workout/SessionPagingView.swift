//
//  SessionPagingView.swift
//  HockeyDrills Watch App
//
//  Created by Vlad Zaharia on 1/12/24.
//

import SwiftUI

struct SessionPagingView: View {
    @Environment(\.isLuminanceReduced) var isLuminanceReduced
    @EnvironmentObject var workoutManager: WorkoutManager
    @EnvironmentObject var drillManager: DrillManager
    @EnvironmentObject var settingsManager: SettingsManager
    @State private var selection: Tab = .metrics
    
    enum Tab {
        case controls, drills, metrics
    }
    
    var body: some View {
        TabView(selection: $selection) {
            ControlsView().tag(Tab.controls)
            
            if (drillManager.isDrillWorkout) {
                DrillStepView().tag(Tab.drills)
            }
            
            MetricsView().tag(Tab.metrics)
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .tabViewStyle(
            PageTabViewStyle(indexDisplayMode: isLuminanceReduced ? .never : .automatic)
        )
        .onAppear {
            settingsManager.fetchSettings {}
            displayDefaultView()
        }
        .onChange(of: workoutManager.running) { _, newValue in
            if newValue {
                displayDefaultView()
            }
        }
        .onChange(of: isLuminanceReduced) { _, _ in
            displayDefaultView()
        }
        .onChange(of: drillManager.currentStep) {
            displayDefaultView()
        }
    }
    
    private func displayDefaultView() {
        withAnimation {
            selection = drillManager.isDrillWorkout ? .drills : .metrics
        }
    }
}

#Preview {
    SessionPagingView()
        .environmentObject(DrillManager())
        .environmentObject(WorkoutManager())
}
