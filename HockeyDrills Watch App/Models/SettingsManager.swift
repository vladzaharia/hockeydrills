//
//  SettingsManager.swift
//  HockeyDrills Watch App
//
//  Created by Vlad Zaharia on 1/14/24.
//

import Foundation

enum DrillLocationsEnum: String, CaseIterable, Identifiable {
    case hockey = "https://assets.polaris.rest/hockeydrills/hockey.json"
    case snoking = "https://assets.polaris.rest/hockeydrills/snoking.json"
    
    case example = "https://assets.polaris.rest/hockeydrills/example.json"
        
    var text: String {
        switch self {
        case .hockey:
            return "Hockey Drills"
        case .snoking:
            return "Sno-King Lessons"
        case .example:
            return "Demo Data"
        }
    }
    
    var id: String { self.rawValue }
}

class SettingsManager: NSObject, ObservableObject {
    static let shared = SettingsManager()
    
    @Published var hasFetchedData: Bool = false
    @Published var drillsUrl: String = ""
    @Published var lastUpdated: String = ""
    
    func clearSettings() {
        UserDefaults.standard.removeObject(forKey: "drills-url")
        UserDefaults.standard.removeObject(forKey: "drills-last-update")
    }
    
    func fetchSettings() {
        drillsUrl = UserDefaults.standard.string(forKey: "drills-url") ?? DrillLocationsEnum.hockey.rawValue
        lastUpdated = UserDefaults.standard.date(forKey: "drills-last-update") ?? "Never updated"
        hasFetchedData = true
    }
    
    func setDrillsUrl(selectedUrl: String) {
        print("Setting drills URL to " + selectedUrl)
        
        UserDefaults.standard.set(selectedUrl, forKey: "drills-url")
        UserDefaults.standard.removeObject(forKey: "drills-last-updated")
    }
    
    func setLastUpdated() {
        UserDefaults.standard.set(Date(), forKey: "drills-last-update")
    }
}

extension UserDefaults {
    func set(date: Date?, forKey key: String){
        self.set(date, forKey: key)
    }
    
    func date(forKey key: String) -> String? {
        let retrievedDate = self.value(forKey: key) as? Date
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        
        if retrievedDate == nil {
            return nil
        }
        
        return formatter.localizedString(for: retrievedDate!, relativeTo: Date())
    }
}
