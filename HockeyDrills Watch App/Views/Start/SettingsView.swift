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
            VStack {
                Picker("Drills to Load", selection: $settingsManager.drillsUrl) {
                    ForEach(DrillLocationsEnum.allCases) { location in
                        Text(location.text).tag(location.id)
                    }
                }
                .pickerStyle(.navigationLink)
                .onChange(of: settingsManager.drillsUrl) {
                    settingsManager.setDrillsUrl(selectedUrl: settingsManager.drillsUrl)
                    drillManager.fetchDrills(force: true)
                }
                
                Spacer()
                
                Button {
                    drillManager.fetchDrills(force: true)
                } label: {
                    Image(systemName: "arrow.counterclockwise")
                }
                .tint(Color.blue)
                .font(.title3)
                            
                Text("Last Updated: " + settingsManager.lastUpdated).font(.footnote).foregroundStyle(Color.secondary)
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .onAppear {
                settingsManager.fetchSettings()
            }
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(SettingsManager())
        .environmentObject(DrillManager())
}
