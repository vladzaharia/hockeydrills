//
//  Drills.swift
//  HockeyDrills Watch App
//
//  Created by Vlad Zaharia on 1/11/24.
//

import Foundation

struct Drill: Identifiable, Codable {
    var id: String
    var name: String
    var icon: String?
    var category: String?
    var defaultDrill: Bool? = false
    var steps: [Step] = []
}

extension Drill: Equatable {
    static func == (lhs: Drill, rhs: Drill) -> Bool {
        return lhs.id == rhs.id
    }
}

struct Step: Identifiable, Codable {
    var id: String
    var text: String
    var qty: Int? = 0
    var minQty: Int?
    var maxQty: Int?
    var descriptor: String?
}

extension Step: Equatable {
    static func == (lhs: Step, rhs: Step) -> Bool {
        return lhs.id == rhs.id
    }
}
