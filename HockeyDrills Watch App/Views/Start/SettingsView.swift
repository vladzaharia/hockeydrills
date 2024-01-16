//
//  SettingsView.swift
//  HockeyDrills Watch App
//
//  Created by Vlad Zaharia on 1/14/24.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settingsManager: SettingsManager
    @EnvironmentObject var drillManager: DrillManager
    
    var body: some View {
        if settingsManager.hasFetchedData {
            ScrollView {
                Section("Drills to Load") {
                    Spacer(minLength: 10)
                    
                    Picker("Drill List", selection: $settingsManager.drillsUrl) {
                        ForEach($settingsManager.drillsUrls) { location in
                            Label(location.name.wrappedValue, systemImage: location.icon.wrappedValue).tag(location.url.wrappedValue)
                        }
                    }
                    .pickerStyle(.navigationLink)
                    .onChange(of: settingsManager.drillsUrl) {
                        settingsManager.setDrillsUrl(selectedUrl: settingsManager.drillsUrl)
                        drillManager.fetchDrills(force: true)
                    }
                    
                    Button {
                        drillManager.fetchDrills(force: true)
                    } label: {
                        Label("Reload", systemImage: "arrow.counterclockwise")
                    }
                    .tint(Color.blue)
                                
                    Text("Last Updated: " + settingsManager.lastUpdated).font(.footnote).foregroundStyle(Color.secondary)
                }
                
                Spacer(minLength: 20)
                Divider()
                Spacer(minLength: 20)
                
                Section("Workout Settings") {
                    Spacer(minLength: 10)
                    
                    Toggle("Show complete button?", isOn: $settingsManager.showCompleteButton)
                    .onChange(of: settingsManager.showCompleteButton) {
                        settingsManager.setShowComplete(showComplete: settingsManager.showCompleteButton)
                    }
                }
            }
            .navigationTitle("Settings")
            .onAppear {
                settingsManager.fetchSettings() {}
            }
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(SettingsManager())
        .environmentObject(DrillManager())
}
