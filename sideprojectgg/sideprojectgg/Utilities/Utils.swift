//
//  Utils.swift
//  sideprojectgg
//
//  Created by Jeremy Villanueva on 1/3/25.
//


import Foundation
import SwiftUI
import Firebase
import FirebaseFunctions
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth
import GoogleSignIn

struct Utils: View {
    @EnvironmentObject var viewModel: ContentViewModel
    let db = Firestore.firestore()
    
//    func handleScanUploadAction() async {
//        
//        
//        // Ensure images are not nil
//        guard let frontImage = viewModel.frontImage, let backImage = viewModel.backImage else {
//            print("Images are missing")
//            return
//        }
//        
//        //compute front and back analysis
//        print("COMPUTATION 1")
//        
//        
//        do {
//            try await viewModel.createFrontAnalysis(img: frontImage)
//            try await viewModel.createBackAnalysis(img: backImage)
//            
//            print("COMPUTATION 2")
//            // Convert and upload images
//            
//            let frontImageData = viewModel.convertImagePNGData(img: frontImage)
//            var uuid = NSUUID().uuidString
//            try await viewModel.uploadFile(data: frontImageData, path: "images/\(uuid).png") { result in
//                switch result {
//                case .success(let downloadURL):
//                    //frontImageURL = downloadURL
//                    viewModel.frontImageURL = downloadURL.absoluteString
//                    print("Upload successful! URL: \(downloadURL)")
//                case .failure(let error):
//                    print("Upload failed: \(error.localizedDescription)")
//                }
//            }
//            print("COMPUTATION 3")
//            
//            //then upload url
//            
//            let backImageData = viewModel.convertImagePNGData(img: backImage)
//            uuid = NSUUID().uuidString
//            try await viewModel.uploadFile(data: backImageData, path: "images/\(uuid).png") { result in
//                switch result {
//                case .success(let downloadURL):
//                    
//                    viewModel.backImageURL = downloadURL.absoluteString
//                    print("Upload successful! URL: \(downloadURL)")
//                case .failure(let error):
//                    print("Upload failed: \(error.localizedDescription)")
//                }
//            }
//            print("COMPUTATION 4")
//        } catch let error {
//            print("Error to Firestore: \(error)")
//        }
//        
//        
//            
//        
//    
//
//    
//        print("COMPUTATION 5")
//        guard let frontImageURL = viewModel.frontImageURL, let backImageURL = viewModel.backImageURL, let frontAnalysis = viewModel.frontAnalysis, let backAnalysis = viewModel.backAnalysis else {
//            print("Scan Fields Are Missing")
//            return
//        }
//        
//        
//        //now that we have the images and analysis, store as a scan in scan collection with the user's UID (so we have to reference AuthViewModel asweell)
//        let scan = ScanObject(userUID: viewModel.uid, frontImage: frontImageURL, backImage: backImageURL, frontAnalysis: frontAnalysis, backAnalysis: backAnalysis)
//        
//        
//        //does NOT WORK because of app check
//        do {
//            try db.collection("scans").addDocument(from: scan)
//        } catch let error {
//            print("Error writing city to Firestore: \(error)")
//            }
//    
//    
//        
//        //store all data in Scan Struct then add to firebase
//        
//        
//    }
    
    
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    Utils()
}
