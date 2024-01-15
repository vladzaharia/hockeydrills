//
//  DrillManager.swift
//  HockeyDrills Watch App
//
//  Created by Vlad Zaharia on 1/12/24.
//

import Foundation

class DrillManager: NSObject, ObservableObject {
    static let shared = DrillManager()
    
    // Internal drill storage
    private var drills: [Drill] = [] {
        didSet {
            let categories = Set(drills.map { $0.category })
            var result: [DrillGroup] = []
            
            for category in categories {
                let finalDrills = drills.filter { $0.category == category && !($0.defaultDrill ?? false) }
                if !finalDrills.isEmpty {
                    result.append(DrillGroup(name: category ?? "Other Drills", drills: finalDrills))
                }
            }
            
            DispatchQueue.main.async {
                self.drillGroups = result
                self.defaultDrill = self.drills.first { $0.defaultDrill ?? false }
                
                SettingsManager.shared.setLastUpdated()
                
                print("Drills updated!")
            }
        }
    }
    
    @Published public var defaultDrill: Drill?
    
    // Public grouped drill listing
    @Published public var drillGroups: [DrillGroup] = []
    
    // Whether the current workout is drill-based
    @Published public var isDrillWorkout: Bool = false
    
    // Current selected drill
    @Published public var selectedDrill: Drill? {
        didSet {
            isDrillWorkout = true
        }
    }
    
    // Current drill step
    @Published public var currentStep: Step?
    
    // Number of completed drill steps
    @Published public var numberCompleted = 0
    
    // Completed drill steps
    private var completedSteps: [Step] = []
    
    func fetchDrills(force: Bool = false) {
        drills = []
        drillGroups = []
        
        // Get settings
        SettingsManager.shared.fetchSettings() {
            let url = URL(string: SettingsManager.shared.drillsUrl)
            
            let sessionConfig = URLSessionConfiguration.default
            
            if force {
                sessionConfig.requestCachePolicy = .reloadIgnoringLocalCacheData
            }
            
            print("Fetching drills from " + url!.absoluteString)
            
            let urlSession = URLSession.init(configuration: sessionConfig).dataTask(with: url!) { (data, response, error) in
                if let error = error {
                    print("Couldn't retrieve data!")
                    print(error)
                    
                    return
                }
                
                if let data = data {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    
                    do {
                        let drills: [Drill] = try decoder.decode([Drill].self, from: data)
                        self.drills = drills
                    } catch let error {
                        // TOOD: error handling
                        print("Couldn't decode drills!")
                        print(error)
                    }
                }
            }
            
            
            // Send the request out
            urlSession.resume()
        }
    }
    
    func startDrill(id: String) {
        let drill = drills.first { $0.id == id }
        
        if drill == nil {
            // TODO: Handle drill not existing
        }
        
        startDrill(drill: drill!)
    }
    
    func startDrill(drill: Drill) {
        selectedDrill = drill
        print("Started drill " + drill.id)
        
        nextStep()
    }
    
    func endDrill() {
        selectedDrill = nil
        isDrillWorkout = false
        numberCompleted = 0
        completedSteps = []
    }
    
    func resetSteps() {
        DispatchQueue.main.async {
            self.completedSteps = []
            self.currentStep = nil
            self.nextStep()
        }
    }
    
    func completeStep() {
        DispatchQueue.main.async {
            if self.selectedDrill == nil || self.currentStep == nil {
                // TODO: Error
                return
            }
            
            // Increment number of completed steps
            self.numberCompleted += 1
            
            self.nextStep()
        }
    }
    
    func skipStep() {
        DispatchQueue.main.async {
            if self.selectedDrill == nil || self.currentStep == nil {
                // TODO: Error
                return
            }
            
            self.nextStep()
        }
    }
    
    private func nextStep() {
        DispatchQueue.main.async {
            if self.currentStep != nil {
                // Add current step to completed list
                self.completedSteps.append(self.currentStep!)
            }
            
            let availableSteps = self.selectedDrill!.steps.filter { step in
                !self.completedSteps.contains { completedStep in
                    step.id == completedStep.id
                }
            }
            
            if availableSteps.isEmpty {
                // Reset completedSteps and re-run
                return self.resetSteps()
            }
            
            var newStep = availableSteps.randomElement()
            if newStep?.minQty != nil && newStep?.maxQty != nil {
                newStep!.qty = Int.random(in: (newStep!.minQty!)...(newStep!.maxQty!))
            }
            
            self.currentStep = newStep
        }
    }
}

struct DrillGroup: Identifiable {
    var id = UUID()
    var name: String
    var drills: [Drill]
}
