//
//  Analysis.swift
//  sideprojectgg
//
//  Created by Jeremy Villanueva on 12/31/24.
//

import SwiftUI



struct FrontAnalysis: Codable {
    let bodyFatPercentage: Int
    let shoulders, chest, abs, arms, quads, calves: Muscle?
}

struct BackAnalysis: Codable {
    let bodyFatPercentage: Int
    let traps, lats, glutes, quads, calves: Muscle?
}

struct Muscle: Codable {
    let rating: Int?
    let description: String?
}

