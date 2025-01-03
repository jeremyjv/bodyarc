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
import FirebaseStorage



@MainActor
class ContentViewModel: ObservableObject {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @Published var text: String = ""
    @Published var frontImage: UIImage?
    @Published var backImage: UIImage?
    
    //these should change when we run the analysis
    @Published var frontAnalysisJSON: Data?
        
    @Published var backAnalysisJSON: Data?
    
    // Initial value for frontAnalysis and backAnalysis (will be updated by didSet observers)
    @Published var frontAnalysis: FrontAnalysis?
    @Published var backAnalysis: BackAnalysis?
    
 
    
    init() {

    }
    
    
        
    let functions = Functions.functions()
    
    
    //whole step to 
    func handleScanUploadAction() {
        Task {
            // Ensure images are not nil
            guard let frontImage = self.frontImage, let backImage = self.backImage else {
                print("Images are missing")
                return
            }
            
            await self.createFrontAnalysis(img: frontImage)
            await self.createBackAnalysis(img: backImage)

            // Convert and upload images
            var frontImageURL: String?
            let frontImageData = self.convertImagePNGData(img: frontImage)
            await self.uploadFile(data: frontImageData, path: "images/front_image.png") { result in
                switch result {
                case .success(let downloadURL):
                    //frontImageURL = downloadURL
                    frontImageURL = downloadURL.absoluteString
                    print("Upload successful! URL: \(downloadURL)")
                case .failure(let error):
                    print("Upload failed: \(error.localizedDescription)")
                }
            }
            
            //then upload url
            var backImageURL: String?
            let backImageData = self.convertImagePNGData(img: backImage)
            await self.uploadFile(data: backImageData, path: "images/back_image.png") { result in
                switch result {
                case .success(let downloadURL):
                    
                    backImageURL = downloadURL.absoluteString
                    print("Upload successful! URL: \(downloadURL)")
                case .failure(let error):
                    print("Upload failed: \(error.localizedDescription)")
                }
            }
            
            //now that we have the images and analysis, store as a scan in scan collection with the user's UID (so we have to reference AuthViewModel asweell)
            
            
            
            
        }
    }
    
    func convertImageToBase64(img: UIImage) -> String {
        return img.jpegData(compressionQuality: 1)!.base64EncodedString()
    }
    func convertImagePNGData(img: UIImage) -> Data {
        return img.pngData()!
    }
    //Firebase STORAGE///
    
    //when we save scan, we save the images and pass it to here to receive back a URL that points back to it
    func uploadFile(data: Data, path: String, completion: @escaping (Result<URL, Error>) -> Void) async {
        let storage = Storage.storage()
        let storageRef = storage.reference().child(path)
        
        storageRef.putData(data, metadata: nil) { metadata, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            storageRef.downloadURL { url, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                if let url = url {
                    completion(.success(url))
                }
            }
        }
    }
    
    
    
    /////CLOUD FUNCTIONS //////
    
    
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
        Functions.functions().useEmulator(withHost: "http://127.0.0.1", port: 5001)
 
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
                        frontAnalysis = try decoder.decode(FrontAnalysis.self, from: frontAnalysisJSON!)
                    } catch {
                        print("Error decoding JSON: \(error)")
                    }
                }
              
               
                print("Function response: \(data)")
            }
        }
  
    }
    
    func createBackAnalysis(img: UIImage) async {
        let base64 = self.convertImageToBase64(img: img)
        
        //let data: [String: Any] = ["base64": base64] // Your arguments
        Functions.functions().useEmulator(withHost: "http://127.0.0.1", port: 5001)
 
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
                        backAnalysis = try decoder.decode(BackAnalysis.self, from: backAnalysisJSON!)
                    } catch {
                        print("Error decoding JSON: \(error)")
                    }
                }
              
            
                print("Function response: \(data)")
            }
        }
  
    }
    
}
