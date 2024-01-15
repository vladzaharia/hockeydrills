//
//  SettingsManager.swift
//  HockeyDrills Watch App
//
//  Created by Vlad Zaharia on 1/14/24.
//

import Foundation

struct DrillsUrl: Identifiable, Codable {
    var id: String
    var name: String
    var icon: String
    var url: String
}

class SettingsManager: NSObject, ObservableObject {
    static let shared = SettingsManager()
    
    @Published var hasFetchedData: Bool = false
    @Published var drillsUrl: String = ""
    @Published var lastUpdated: String = ""
    @Published var drillsUrls: [DrillsUrl] = []
    
    func clearSettings() {
        UserDefaults.standard.removeObject(forKey: "drills-url")
        UserDefaults.standard.removeObject(forKey: "drills-last-update")
    }
    
    func fetchSettings(completion: @escaping ()->()) {
        fetchDrillUrls() {
            let defaultDrillUrl = self.drillsUrls.first { $0.id == "1beaa7e5-46a3-45f9-96ba-ad17f4c2b194" }
            
            self.drillsUrl = UserDefaults.standard.string(forKey: "drills-url") ?? (defaultDrillUrl?.url ?? "")
            self.lastUpdated = UserDefaults.standard.date(forKey: "drills-last-update") ?? "Never updated"
            
            self.hasFetchedData = true
            
            completion()
        }
    }
    
    func fetchDrillUrls(completion: @escaping ()->()) {
        let url = "https://assets.polaris.rest/hockeydrills/_list.json"
        
        print("Fetching drill URLs from " + url)
        
        let urlSession = URLSession.init(configuration: URLSessionConfiguration.default).dataTask(with: URL(string: url)!) { (data, response, error) in
            if let error = error {
                print("Couldn't retrieve data!")
                print(error)
                
                return
            }
            
            if let data = data {
                DispatchQueue.main.async {
                    do {
                        let drillsUrls: [DrillsUrl] = try JSONDecoder().decode([DrillsUrl].self, from: data)
                        self.drillsUrls = drillsUrls
                        completion()
                    } catch let error {
                        // TOOD: error handling
                        print("Couldn't decode drill list!")
                        print(error)
                    }
                }
            } else {
                completion()
            }
        }
        
        
        // Send the request out
        urlSession.resume()
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
