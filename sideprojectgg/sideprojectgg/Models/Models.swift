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
    let email: String?
    let uid: String?
    let intake: IntakeForm?
    
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
struct ScanObject: Codable, Hashable {
    var userUID: String?
    var frontImage: String?
    var backImage: String?
    var frontAnalysis: FrontAnalysis?
    var backAnalysis: BackAnalysis?
    var createdAt: Date?
    
    


    
    init(createdAt: Date?, userUID: String?, frontImage: String?, backImage: String?, frontAnalysis: FrontAnalysis?, backAnalysis: BackAnalysis?) {
            self.userUID = userUID
            self.frontImage = frontImage
            self.backImage = backImage
            self.frontAnalysis = frontAnalysis
            self.backAnalysis = backAnalysis
            self.createdAt = createdAt
        
        }
    
    init() {
        userUID = nil
        frontImage = nil
        backImage = nil
        frontAnalysis = nil
        backAnalysis = nil
        createdAt = nil
    }
    
//    func getScanObject(scanId: String) async -> ScanObject {
//        
//    }
//    
   
}

struct Rating: Codable {
    
    //slide 1
    var vTaper: Int

    var overall: Int
    var potential: Int
    
    
    
    //slide 3
    var clavicalWidth: Int
    var waistSize: Int
    
    //Back analysis now so optional
    //slide 4
    var traps: Int?
    var lats: Int?
    var thickness: Int?
    var width: Int?
    
    //slide 5 highlights -> if none recognize potential
    
    
    //slide 6 Potential Overall comparison
    
    //slide 7 leaness
    
    //slide 8 Masculinity
    
    //slide 9 Potential
    
    //slide 10
                
    //your highlights
    var muscleHighlights: [String]
    
}

struct FrontAnalysis: Codable, Hashable {
    let bodyFatPercentage: Int
    let shoulders, chest, abs, arms: Muscle?
}

struct BackAnalysis: Codable, Hashable {
    let bodyFatPercentage: Int
    let traps, lats: Muscle?
}

struct Muscle: Codable, Hashable {
    let rating: Int?
    let description: String?
}






