//
//  Analysis.swift
//  sideprojectgg
//
//  Created by Jeremy Villanueva on 12/31/24.
//

import SwiftUI



struct Analysis: Codable {
    let bodyFatPercentage: Int
    let shoulders, chest, abs, arms, quads, calves: Muscle
  
}


struct Muscle: Codable {
    let rating: Int
    let description: String
}

//use this on front and back analysis, and store in viewModel 
extension Analysis {
    static func decode(from jsonData: Data) -> Analysis? {
        let decoder = JSONDecoder()
                do {
                    return try decoder.decode(Analysis.self, from: jsonData)
                } catch {
                    print("Decoding error: \(error)")
                    return nil
                }
    }
}
