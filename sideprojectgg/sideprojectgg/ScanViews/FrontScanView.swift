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
    @EnvironmentObject var viewModel: ContentViewModel
    @ObservedObject var cameraModel: CameraModel
    @State private var showCamera: Bool = false
    @State private var defaultImage: UIImage?
    @State private var photosPickerItem: PhotosPickerItem?
    @State private var showPicker: Bool = false
    @State private var showOptionsMenu: Bool = false

    let generator = UIImpactFeedbackGenerator(style: .heavy)

    var body: some View {
        VStack(spacing: 16) {
            Text("Upload a front selfie")
                .font(.title2)
                .bold()

            // Image or Camera View
            ZStack {
                // Default Image or Captured Image
                if !showCamera {
                    Image(uiImage: defaultImage ?? UIImage(named: "scanImage")!)
                        .resizable()
                        .scaledToFill() // Fill the frame proportionally
                        .frame(width: 275, height: 445) // Maintain the aspect ratio
                        .cornerRadius(20)
                        .clipped()
                } else {
                    // Camera Preview
                    CameraPreview(cameraModel: cameraModel)
                        .scaledToFill()
                        .frame(width: 275, height: 445) // Same frame as the default image
                        .cornerRadius(20)
                        .clipped()
                }
            }
            .frame(width: 275, height: 445) // Ensure consistent dimensions
            .cornerRadius(20)

            // Single Action Button
            Button(action: {
                showOptionsMenu = true // Show menu popup
            }) {
                Text("Upload or take selfie")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.purple)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .confirmationDialog("Choose an option", isPresented: $showOptionsMenu, titleVisibility: .visible) {
                Button("Take a Selfie") {
                    cameraModel.checkAuthorization()
                    showCamera = true
                }
                Button("Upload from Photo Library") {
                    showPicker = true
                }
                Button("Cancel", role: .cancel) {}
            }
            .padding()

            Spacer()
        }
        .padding()
        .onChange(of: cameraModel.capturedImage) { _, newImage in
            if let newImage = newImage {
                // Update the default image and view model
                defaultImage = newImage
                viewModel.frontImage = newImage

                // Stop the camera session and close the camera view
                cameraModel.stopSession()
                showCamera = false
            }
        }
        .onChange(of: photosPickerItem) { _, _ in
            Task {
                if let photosPickerItem,
                   let data = try? await photosPickerItem.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    // Update the default image and view model with the selected image
                    defaultImage = image
                    viewModel.frontImage = image
                }
            }
        }
        .onDisappear {
            // Stop the camera session if the view is dismissed
            if showCamera {
                cameraModel.stopSession()
            }
        }
        // Photo Library Picker
        .photosPicker(isPresented: $showPicker, selection: $photosPickerItem)
    }
}

#Preview {
    //FrontScanView(cameraModel: _cameraModel)
}

