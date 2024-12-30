//
//  ScanView.swift
//  sideprojectgg
//
//  Created by Jeremy Villanueva on 12/29/24.
//


import Foundation
import SwiftUI
import Firebase
import FirebaseFunctions
import PhotosUI
import FirebaseFirestore

struct RectangleComponent: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(Color.gray.opacity(0.3)) // Adjust color and opacity
    }
}


struct ScanView: View {
    @EnvironmentObject var viewModel: ContentViewModel
    @StateObject private var cameraModel = CameraModel()
    
    @State private var defaultImage: UIImage?
    @State private var photosPickerItem: PhotosPickerItem?
    @State private var analysis: String?

    @State private var path = NavigationPath() // To manage navigation
    
    struct User: Identifiable, Codable {
        @DocumentID var id: String?
        var name: String
    }
    
    @FirestoreQuery(collectionPath: "user")
    var users: [User]
    

    

    var body: some View {
        NavigationStack(path: $path) {
            
  
            
            VStack(spacing: 16) {
                
                Text(" \(users)")
                
                
                HStack {
                    Image(uiImage: viewModel.frontImage ?? UIImage(named: "scanImage")!)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                    
                    Image(uiImage: viewModel.backImage ?? UIImage(named: "scanImage")!)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                    
                }
               
        
                
                
                Image(uiImage: UIImage(named: "scanImage")!)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 300, height: 300)
                
                Text( "Analysis: \(viewModel.frontAnalysis)") // Display the result if it exists
                
                
            
                
                

 
            
                Button(action: {
                    path.append("FrontScanView")
                }) {
                    Text("Begin Scan")
                }
                .navigationDestination(for: String.self) { destination in
                    switch destination {
                        case "FrontScanView":
                            FrontScanView(cameraModel: cameraModel, path: $path)
                            
                        case "FrontCameraView":
                            FrontCameraView(cameraModel: cameraModel, path: $path)
                        
                        case "BackScanView":
                            BackScanView(cameraModel: cameraModel, path: $path)
                        
                        case "BackCameraView":
                            BackCameraView(cameraModel: cameraModel, path: $path)
                        
                
                        default:
                            ContentView()
                        }
                    
                }
                
                
                
                Spacer()
                
            
            }
            .padding()
            .onChange(of: viewModel.frontImage) {_, _ in
                Task {
                    defaultImage = viewModel.frontImage
                }
            }
           
        
        }
        
    }
}
    

#Preview {
    ContentView()
}
