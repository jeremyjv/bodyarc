//
//  BackViewScan.swift
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
struct BackScanView: View {
    @EnvironmentObject var viewModel: ContentViewModel
    @ObservedObject var cameraModel: CameraModel
    @State private var isShowingOptions = false // To toggle the menu
    
    @State private var defaultImage: UIImage?
    @State private var photosPickerItem: PhotosPickerItem?
    @State private var showPicker: Bool = false // For PhotosPicker
    @State private var showCamera: Bool = false // For Selfie
    @State private var analysis: String?
    

    @Environment(\.dismiss) var dismiss
    @Binding var path: NavigationPath

    var body: some View {
        
      
            VStack(spacing: 16) {
                // Top Rectangle
                RectangleComponent()
                
                    .frame(height: 50) // Adjust height as per your mockup
                Text("Upload Back Selfie")
                
                // Middle Rectangle
                Image(uiImage: defaultImage ?? UIImage(named: "scanImage")!)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 300, height: 300)
                    .onChange(of: cameraModel.capturedImage) {_, _ in
                        Task {
                            defaultImage = cameraModel.capturedImage
                            viewModel.backImage = cameraModel.capturedImage
                        }
                    }
                
                
                //Select Photo from camera roll
                //if default image = UIImage(named: "scanImage") else "retake photo" / "use photo" -> backscanview
                //have this open as a menu instead
                if defaultImage == nil {
                    Button(action: {
                        isShowingOptions = true // Show the menu
                        showPicker = false
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
                            path.append("BackCameraView")
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
                  

                } else {
                    Button(action: {
                        isShowingOptions = true
                        showPicker = false
                    }) {
                        Text("Use Another")
                    }
                    .confirmationDialog("Select an option", isPresented: $isShowingOptions, titleVisibility: .visible) {
                        Button(action: {
                            path.append("BackCameraView")
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
                    
                    
                    
                    Button(action: {
                        //return to contentView with empty path
                        path = NavigationPath()
                        
                        //run paywall business logic
                        
                        
                        //run analysis logic here  --> create different
                        Task {
                            await viewModel.createFrontAnalysis(img: viewModel.frontImage!)
                            
                            //--> create different function for back analysis
                            
                        }
                     
                        
                        //--> create different function for back analysis
                        
         
                    }) {
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
                            viewModel.backImage = image
                            
                            
                            
                        }
                    }
                    photosPickerItem = nil
                }
            }
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        path.removeLast() // Custom back button action
                    }) {
                        HStack {
                            Image(systemName: "chevron.left") // Custom back button icon
                        }
                    }
                }
            }
            .onChange(of: viewModel.backImage) { _, _ in
                print("Back Image updated to new image")
            }
            
        }
        
    
}

#Preview {
    ContentView()
}
