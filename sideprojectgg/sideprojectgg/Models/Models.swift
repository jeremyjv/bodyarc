//
//  Analysis.swift
//  sideprojectgg
//
//  Created by Jeremy Villanueva on 12/31/24.
//

import SwiftUI


//create the structs that will eventually be retrieved, passed to firestore

//practice passing one instance to firestore

struct User: Codable {
    let email: String?
    let uid: String?
    let scans: [Scan]?
    
}

//this will be editable in the top right profile section (gear icon)
struct IntakeForm: Codable {
    let gender: String?
    let goal: String?
    let availability: Int?
    
    init() {
        gender = nil
        goal = nil
        availability = nil
    }
}

//need to eventually serialize to pass to firebase photo.pngData()!
struct Scan: Codable {
    let frontImage: Data?
    let backImage: Data?
    let frontAnalysis: FrontAnalysis?
    let backAnalysis: BackAnalysis?
}

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






