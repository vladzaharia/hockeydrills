//
//  Drills.swift
//  HockeyDrills Watch App
//
//  Created by Vlad Zaharia on 1/11/24.
//

import Foundation

struct Drill: Identifiable {
    var id: String
    var name: String
    var icon: String = "checklist"
    var category: String = "Other Drills"
    var defaultDrill = false
    var steps: [Step] = []
}

extension Drill: Equatable {
    static func == (lhs: Drill, rhs: Drill) -> Bool {
        return lhs.id == rhs.id
    }
}

struct Step: Identifiable {
    var id: String
    var text: String
    var qty = 0
    var minQty: Int?
    var maxQty: Int?
    var descriptor: String?
}

extension Step: Equatable {
    static func == (lhs: Step, rhs: Step) -> Bool {
        return lhs.id == rhs.id
    }
}
