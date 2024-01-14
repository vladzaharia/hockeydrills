//
//  ResumeIntent.swift
//  HockeyDrills Watch App
//
//  Created by Vlad Zaharia on 1/13/24.
//

import Foundation
import AppIntents

struct ResumeHDWorkoutIntent: PauseWorkoutIntent {
   static var title: LocalizedStringResource = "Resume Workout"

   func perform() async throws -> some IntentResult {
       WorkoutManager.shared.resume()
       return .result()
   }
}
