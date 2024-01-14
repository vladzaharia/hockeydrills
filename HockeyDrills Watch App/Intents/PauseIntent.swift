//
//  PauseIntent.swift
//  HockeyDrills Watch App
//
//  Created by Vlad Zaharia on 1/13/24.
//

import Foundation
import AppIntents

struct PauseHDWorkoutIntent: PauseWorkoutIntent {
   static var title: LocalizedStringResource = "Pause Workout"

   func perform() async throws -> some IntentResult {
       WorkoutManager.shared.pause()
       return .result()
   }
}
