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
    let scans: [ScanObject]?
    
}

//this will be editable in the top right profile section (gear icon)
struct IntakeForm: Codable {
    var gender: String?
    var goal: String?
    var availability: String?
    
    init() {
        gender = nil
        goal = nil
        availability = nil
    }
}

//need to eventually serialize to pass to firebase photo.pngData()!
struct ScanObject: Codable {
    var userUID: String?
    var frontImage: String?
    var backImage: String?
    var frontAnalysis: FrontAnalysis?
    var backAnalysis: BackAnalysis?
    
    init(userUID: String?, frontImage: String?, backImage: String?, frontAnalysis: FrontAnalysis?, backAnalysis: BackAnalysis?) {
            self.userUID = userUID
            self.frontImage = frontImage
            self.backImage = backImage
            self.frontAnalysis = frontAnalysis
            self.backAnalysis = backAnalysis
        }
    
    init() {
        userUID = nil
        frontImage = nil
        backImage = nil
        frontAnalysis = nil
        backAnalysis = nil
    }
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






