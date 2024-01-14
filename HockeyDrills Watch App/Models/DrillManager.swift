//
//  DrillManager.swift
//  HockeyDrills Watch App
//
//  Created by Vlad Zaharia on 1/12/24.
//

import Foundation

@Observable class DrillManager: NSObject, ObservableObject {
    static let shared = DrillManager()
    
    // Internal drill storage
    private var drills: [Drill] = [] {
        didSet {
            let categories = Set(drills.map { $0.category })
            var result: [DrillGroup] = []
            
            for category in categories {
                result.append(DrillGroup(name: category ?? "Other Drills", drills: drills.filter { $0.category == category && !($0.defaultDrill ?? false) }))
            }
            
            drillGroups = result
        }
    }
    
    public var defaultDrill: Drill? {
        get {
            return drills.first { $0.defaultDrill ?? false }
        }
    }
    
    // Public grouped drill listing
    public var drillGroups: [DrillGroup] = []
    
    // Whether the current workout is drill-based
    public var isDrillWorkout: Bool {
        get {
            return selectedDrill != nil
        }
    }
    
    // Current selected drill
    public var selectedDrill: Drill?
    
    // Current drill step
    public var currentStep: Step?
    
    // Number of completed drill steps
    public var numberCompleted = 0
    
    // Completed drill steps
    private var completedSteps: [Step] = []
    
    func fetchDrills() {
        print("Fetching drills...")
        
        if let url = URL(string: "https://assets.polaris.rest/hockeydrills/example.json") {
            let urlSession = URLSession.init(configuration: URLSessionConfiguration.default).dataTask(with: url) { (data, response, error) in
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
        numberCompleted = 0
        completedSteps = []
    }
    
    func resetSteps() {
        completedSteps = []
        currentStep = nil
        nextStep()
    }
    
    func completeStep() {
        if selectedDrill == nil || currentStep == nil {
            // TODO: Error
            return
        }
        
        // Increment number of completed steps
        numberCompleted += 1
        
        nextStep()
    }
    
    func skipStep() {
        if selectedDrill == nil || currentStep == nil {
            // TODO: Error
            return
        }
        
        nextStep()
    }
    
    private func nextStep() {
        if currentStep != nil {
            // Add current step to completed list
            completedSteps.append(currentStep!)
        }
                
        let availableSteps = selectedDrill!.steps.filter { step in
            !completedSteps.contains { completedStep in
                step.id == completedStep.id
            }
        }
        
        if availableSteps.isEmpty {
            // Reset completedSteps and re-run
            return resetSteps()
        }
        
        var newStep = availableSteps.randomElement()
        if newStep?.qty == 0 && newStep?.minQty != nil && newStep?.maxQty != nil {
            newStep!.qty = Int.random(in: (newStep!.minQty!)...(newStep!.maxQty!))
        }
        
        currentStep = newStep
    }
}

struct DrillGroup: Identifiable {
    var id = UUID()
    var name: String
    var drills: [Drill]
}
