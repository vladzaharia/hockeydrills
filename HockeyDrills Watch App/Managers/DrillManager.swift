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
    private var drills: [Drill] = [
        Drill(id: "example", name: "Example Drill", defaultDrill: true, steps: [
            Step(id: UUID().uuidString, text: "Something", qty: 1),
            Step(id: UUID().uuidString, text: "Something Else", qty: 1, descriptor: "across the rink"),
            Step(id: UUID().uuidString, text: "And another", minQty: 1, maxQty: 5),
            Step(id: UUID().uuidString, text: "Another one", qty: 1),
            Step(id: UUID().uuidString, text: "DJ Khaled", qty: 1, descriptor: "in da house!")
        ]),
        Drill(id: "example2", name: "Example Drill 2", icon: "figure.hockey", steps: [
           Step(id: UUID().uuidString, text: "Something", qty: 1),
           Step(id: UUID().uuidString, text: "Something Else", qty: 1, descriptor: "across the rink and back")
        ]),
        Drill(id: "example3", name: "Example Drill 3", icon: "hockey.puck.fill", steps: [
           Step(id: UUID().uuidString, text: "Something", qty: 1),
           Step(id: UUID().uuidString, text: "Something Else", qty: 1, descriptor: "Across the rink")
        ]),
        Drill(id: "example4", name: "Example Drill 4", icon: "hockey.puck", steps: [
           Step(id: UUID().uuidString, text: "Something", qty: 1),
           Step(id: UUID().uuidString, text: "Something Else", qty: 1, descriptor: "Across the rink")
        ])]
    
    public var defaultDrill: Drill? {
        get {
            return drills.first { $0.defaultDrill }
        }
    }
    
    // Public grouped drill listing
    public var drillGroups: [DrillGroup] {
        get {
            let categories = Set(drills.map { $0.category })
            var result: [DrillGroup] = []
            
            for category in categories {
                result.append(DrillGroup(name: category, drills: drills.filter { $0.category == category && !$0.defaultDrill }))
            }
            
            return result
        }
    }
    
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
