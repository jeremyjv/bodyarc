//
//  ContentViewModel.swift
//  sideprojectgg
//
//  Created by Jeremy Villanueva on 12/7/24.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseFunctions
import FirebaseFirestore



@MainActor
class ContentViewModel: ObservableObject {
    
    @Published var text: String = ""
    @Published var frontImage: UIImage?
    @Published var backImage: UIImage?
    
    //these should change when we run the analysis
    @Published var frontAnalysisJSON: Data?
        
    @Published var backAnalysisJSON: Data?
    
    // Initial value for frontAnalysis and backAnalysis (will be updated by didSet observers)
    @Published var frontAnalysis: Analysis?
    @Published var backAnalysis: Analysis?
    
    init() {

    }
    
    
        
    let functions = Functions.functions()
    
    func convertImageToBase64(img: UIImage) -> String {
        return img.jpegData(compressionQuality: 1)!.base64EncodedString()
    }
    
    func callHelloWorld() async -> String {
        Functions.functions().useEmulator(withHost: "http://127.0.0.1", port: 5001)
        var text = "hello"
        functions.httpsCallable("helloWorld").call { result, error in
            
            if let error = error {
                print("Error calling function: \(error)")
                return
            }
            if let data = result?.data as? String {
               
                text = data
                print("text:", self.text)
                print("Function response: \(data)")
            }
        }
        
        return text
    }
    
    
    // make separate analysis function for front and back analysis
    func createFrontAnalysis(img: UIImage) async {
        let base64 = self.convertImageToBase64(img: img)
        
        //let data: [String: Any] = ["base64": base64] // Your arguments
        Functions.functions().useEmulator(withHost: "http://10.0.0.101", port: 5001)
 
        functions.httpsCallable("returnFrontAnalysis").call(base64) { result, error in
            
            if let error = error {
                print("Error calling function: \(error)")
                return
            }
            if let data = result?.data as? String {
                
                Task { [weak self] in
                    guard let self else {return}
                    
                    do {
                        frontAnalysisJSON = data.data(using: .utf8)
                        let decoder = JSONDecoder()
                        frontAnalysis = try decoder.decode(Analysis.self, from: frontAnalysisJSON!)
                    } catch {
                        print("Error decoding JSON: \(error)")
                    }
                }
              
                print("text:", data)
                print("Function response: \(data)")
            }
        }
  
    }
    
    func createBackAnalysis(img: UIImage) async {
        let base64 = self.convertImageToBase64(img: img)
        
        //let data: [String: Any] = ["base64": base64] // Your arguments
        Functions.functions().useEmulator(withHost: "http://10.0.0.101", port: 5001)
 
        functions.httpsCallable("returnBackAnalysis").call(base64) { result, error in
            
            if let error = error {
                print("Error calling function: \(error)")
                return
            }
            if let data = result?.data as? String {
                
                Task { [weak self] in
                    guard let self else {return}
                    
                    do {
                        backAnalysisJSON = data.data(using: .utf8)
                        let decoder = JSONDecoder()
                        backAnalysis = try decoder.decode(Analysis.self, from: backAnalysisJSON!)
                    } catch {
                        print("Error decoding JSON: \(error)")
                    }
                }
              
                print("text:", data)
                print("Function response: \(data)")
            }
        }
  
    }
    
}
