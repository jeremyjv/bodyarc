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

@MainActor
final class ContentViewModel: ObservableObject {
    @Published var text: String = ""
    @Published var image: String = ""
    
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
    
    
    
    func imageToAnalysis(img: UIImage) async {
        let base64 = self.convertImageToBase64(img: img)
        //let data: [String: Any] = ["base64": base64] // Your arguments
        Functions.functions().useEmulator(withHost: "http://127.0.0.1", port: 5001)
 
        functions.httpsCallable("returnAnalysis").call(base64) { result, error in
            
            if let error = error {
                print("Error calling function: \(error)")
                return
            }
            if let data = result?.data as? String {
                
                Task { [weak self] in
                    guard let self else {return}
                    self.text = data
                }
            
            
                print("text:", self.text)
                print("Function response: \(data)")
            }
        }
        
    }
    
}
