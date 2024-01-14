//
//  CompleteDrillIntent.swift
//  HockeyDrills Watch App
//
//  Created by Vlad Zaharia on 1/13/24.
//

import Foundation
import AppIntents

struct SkipStepIntent: AppIntent {
    static var title: LocalizedStringResource = "Skip Drill Step"
    
    func perform() async throws -> some IntentResult {
        DrillManager.shared.skipStep()
        return .result()
    }
}
