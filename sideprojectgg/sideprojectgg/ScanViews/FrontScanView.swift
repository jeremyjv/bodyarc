//
//  FrontViewScan.swift
//  sideprojectgg
//
//  Created by Jeremy Villanueva on 12/26/24.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseFunctions
import PhotosUI

//make it so that when the default front image is showing it asks to upload or take picture
//when custom picture is loaded into view, it asks to retake or use the image
struct FrontScanView: View {
    @StateObject private var viewModel = ContentViewModel()
    @ObservedObject var cameraModel: CameraModel
    @State private var isShowingOptions = false // To toggle the menu
    
    @State private var defaultImage: UIImage?
    @State private var photosPickerItem: PhotosPickerItem?
    @State private var showPicker: Bool = false // For PhotosPicker
    @State private var showCamera: Bool = false // For Selfie
    @State private var analysis: String?

    var body: some View {
        NavigationStack {
            
            VStack(spacing: 16) {
                // Top Rectangle
                RectangleComponent()
                
                    .frame(height: 50) // Adjust height as per your mockup
                Text("Upload Front Selfie")
                
                // Middle Rectangle
                Image(uiImage: defaultImage ?? UIImage(named: "scanImage")!)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 300, height: 300)
                    .onChange(of: cameraModel.capturedImage) {_, _ in
                        Task {
                            defaultImage = cameraModel.capturedImage
                        }
                    }
                
                
                //Select Photo from camera roll
                //if default image = UIImage(named: "scanImage") else "retake photo" / "use photo" -> backscanview
                //have this open as a pmenu instead
                if defaultImage == nil {
                    Button(action: {
                        isShowingOptions = true // Show the menu
                    }) {
                        Text("Upload or take selfie")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding()
                    .confirmationDialog("Select an option", isPresented: $isShowingOptions, titleVisibility: .visible) {
                        
                        
                        Button(action: {
                            showCamera.toggle()
                        })
                        {
                            Text("Take a selfie")
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        
                        Button(action: {
                            showPicker.toggle()
                        }) {
                            Text("Upload Image")
                        }
                        
                        
                    }
                    .photosPicker(isPresented: $showPicker, selection: $photosPickerItem)
                    .navigationDestination(isPresented: $showCamera) {
                            FrontCameraView(cameraModel: cameraModel).navigationBarBackButtonHidden(true)
                    }
            
                    
                    
                    
                    
                } else {
                    Text("-Use Another-") //re
                    NavigationLink(destination: BackScanView()) {
                        Text("-Continue-")
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
    //FrontScanView(cameraModel: _cameraModel)
}

