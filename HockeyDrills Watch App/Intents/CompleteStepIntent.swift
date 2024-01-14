//
//  CompleteDrillIntent.swift
//  HockeyDrills Watch App
//
//  Created by Vlad Zaharia on 1/13/24.
//

import Foundation
import AppIntents

struct CompleteStepIntent: AppIntent {
    static var title: LocalizedStringResource = "Complete Drill Step"
    
    func perform() async throws -> some IntentResult {
        DrillManager.shared.completeStep()
        return .result()
    }
}
