//
//  StartDrillIntent.swift
//  HockeyDrills Watch App
//
//  Created by Vlad Zaharia on 1/13/24.
//

import Foundation
import AppIntents

enum DrillEnum: String, AppEnum {
    // List the types of workout your app supports.
    case defaultDrill

    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Drill"

    // Define the display representation for each of the workouts your app supports.
    static var caseDisplayRepresentations: [DrillEnum: DisplayRepresentation] =
    [.defaultDrill: DisplayRepresentation(title: "Default Drill", subtitle: "See app for which drill will be run")]
}

struct StartDrillIntent: StartWorkoutIntent {
    // Define the intent's title.
    static var title: LocalizedStringResource = "Start Drill"
    
    // Define a parameter that specifies the type of workout that this
    // intent starts.
    @Parameter(title: "Drill")
    var workoutStyle: DrillEnum

    // Define a list of start workout intents that appear below the First Press
    // settings when someone sets your app as the workout app in
    // Settings > Action Button.
    static var suggestedWorkouts: [StartDrillIntent] = [StartDrillIntent()]

    // Set the display representation based on the current workout style.
    var displayRepresentation: DisplayRepresentation {
        DrillEnum.caseDisplayRepresentations[workoutStyle] ??
            DisplayRepresentation(title: "Unknown")
    }
    
    // Launch your app when the system triggers this intent.
    static var openAppWhenRun: Bool { true }
    
    // Define an init method that sets the default workout type.
    init() {
        workoutStyle = .defaultDrill
    }

    // Define the method that the system calls when it triggers this event.
    func perform() async throws -> some IntentResult {
        // Get Authorization
        WorkoutManager.shared.requestAuthorization()
        
        DispatchQueue.main.async {
            // Fetch drills
            DrillManager.shared.fetchDrills()
            
            // Start default drill, if available
            if (DrillManager.shared.defaultDrill != nil) {
                DrillManager.shared.startDrill(drill: DrillManager.shared.defaultDrill!)
            }
            
            // Start workout
            WorkoutManager.shared.startWorkout(workoutType: .skatingSports)
        }
        
        return .result()
    }
}
