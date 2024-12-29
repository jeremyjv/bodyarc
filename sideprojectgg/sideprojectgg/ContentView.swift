//
//  ContentView.swift
//  sideprojectgg
//
//  Created by Jeremy Villanueva on 12/2/24.
//
import Foundation
import SwiftUI
import Firebase
import FirebaseFunctions
import PhotosUI

struct RectangleComponent: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(Color.gray.opacity(0.3)) // Adjust color and opacity
    }
}


struct ContentView: View {
    @EnvironmentObject var viewModel: ContentViewModel
    @StateObject private var cameraModel = CameraModel()
    
    @State private var defaultImage: UIImage?
    @State private var photosPickerItem: PhotosPickerItem?
    @State private var analysis: String?

    @State private var path = NavigationPath() // To manage navigation
    

    

    var body: some View {
        NavigationStack(path: $path) {
            
  
            
            VStack(spacing: 16) {
                
                
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
               
                // Top Rectangle
                RectangleComponent()
                    .frame(height: 50) // Adjust height as per your mockup
                
                // Middle Rectangle
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
                
                // Bottom Navigation Bar
                HStack(spacing: 16) {
                    ForEach(0..<4) { _ in
                        RectangleComponent()
                            .frame(width: 50, height: 50) // Adjust size as per your mockup
                    }
                }
                .padding(.bottom, 16)
            }
            .padding()
            .onChange(of: viewModel.frontImage) {_, _ in
                Task {
                    defaultImage = viewModel.frontImage
                }
            }
            TabView {
                ProgressView().tabItem({
                    Label("Home", systemImage: "person")
                })
                
            }
        
        }
        
    }
}
    

#Preview {
    ContentView()
}
