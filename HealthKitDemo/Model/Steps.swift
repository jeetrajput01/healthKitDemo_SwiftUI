//
//  Steps.swift
//  HealthKitDemo
//
//  Created by differenz147 on 01/11/21.
//

import Foundation

struct Step: Identifiable, Codable {
    var id = UUID()
    var count: Int
    var date: Date
}
