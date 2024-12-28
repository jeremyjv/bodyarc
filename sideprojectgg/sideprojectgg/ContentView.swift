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
    @StateObject private var viewModel = ContentViewModel()
    @StateObject private var cameraModel = CameraModel()
    
    @State private var defaultImage: UIImage?
    @State private var photosPickerItem: PhotosPickerItem?
    @State private var analysis: String?

    @State private var path = NavigationPath() // To manage navigation
    

    

    var body: some View {
        NavigationStack(path: $path) {
            
            VStack(spacing: 16) {
                // Top Rectangle
                RectangleComponent()
                    .frame(height: 50) // Adjust height as per your mockup
                
                // Middle Rectangle
                Image(uiImage: defaultImage ?? UIImage(named: "scanImage")!)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 300, height: 300)
                
                Text( "Analysis: \(viewModel.text)") // Display the result if it exists

 
            
                Button(action: {
                    path.append("FrontScanView")
                }) {
                    Text("Begin Scan")
                }
                .navigationDestination(for: String.self) { destination in
                    switch destination {
                        case "FrontScanView":
                            FrontScanView(cameraModel: cameraModel, path: $path)
//                            .navigationBarBackButtonHidden(true)
//                            .toolbar {
//                                ToolbarItem(placement: .navigationBarLeading) {
//                                    Button(action: {
//                                        path.removeLast(path.count) // Custom back button action
//                                    }) {
//                                        HStack {
//                                            Image(systemName: "chevron.left") // Custom back button icon
//                                        }
//                                    }
//                                }
//                            }
                        case "FrontCameraView":
                            FrontCameraView(cameraModel: cameraModel, path: $path)
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
            .onChange(of: photosPickerItem) {_, _ in
                Task {
                    if let photosPickerItem,
                       let data = try? await photosPickerItem.loadTransferable(type: Data.self) {
                        if let image = UIImage(data: data) {
                            defaultImage = image
                            await viewModel.imageToAnalysis(img: defaultImage!)
                        }
                    }
                    photosPickerItem = nil
                }
            }
        
        }
        
    }
}
    

#Preview {
    ContentView()
}
