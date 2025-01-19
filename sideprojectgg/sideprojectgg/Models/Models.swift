//
//  Analysis.swift
//  sideprojectgg
//
//  Created by Jeremy Villanueva on 12/31/24.
//

import SwiftUI
import FirebaseFirestore


//create the structs that will eventually be retrieved, passed to firestore

//practice passing one instance to firestore

struct User: Codable {
    var email: String?
    var uid: String?
    var intake: IntakeForm?
    var muscleRanking: [String]?
    var userReferral: String?
    
}

//this will be editable in the top right profile section (gear icon)
struct IntakeForm: Codable {
    var gender: String?
    var goal: String?
    var availability: String?
    var muscleToGrow: String?
    
    init() {
        gender = nil
        goal = nil
        availability = nil
        muscleToGrow = nil
    }
}



//need to eventually serialize to pass to firebase photo.pngData()!
struct ScanObject: Codable, Hashable {
    var userUID: String?
    var frontImage: String?
    var backImage: String?
    var frontAnalysis: FrontAnalysis?
    var backAnalysis: BackAnalysis?
    var createdAt: Date?
    var muscleRanking: [String]?
    
    


    
    init(createdAt: Date?, userUID: String?, frontImage: String?, backImage: String?, frontAnalysis: FrontAnalysis?, backAnalysis: BackAnalysis?, muscleRanking: [String]?) {
            self.userUID = userUID
            self.frontImage = frontImage
            self.backImage = backImage
            self.frontAnalysis = frontAnalysis
            self.backAnalysis = backAnalysis
            self.createdAt = createdAt
            self.muscleRanking = muscleRanking
         
        }
    
    init() {
        userUID = nil
        frontImage = nil
        backImage = nil
        frontAnalysis = nil
        backAnalysis = nil
        createdAt = nil
    }
    

   
}



struct FrontAnalysis: Codable, Hashable {
    let bodyFatPercentage, overall, vTaper, potential, shoulders, chest, abs, arms: Int
    let clavicleWidth, waistSize, bodyType: String?
    
}

struct BackAnalysis: Codable, Hashable {
    let traps, lats, rearDelts, lowerBack: Int
    let latInsertion, density, width: String

}







