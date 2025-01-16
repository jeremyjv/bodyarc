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
    @State private var isTimerEnabled: Bool = false // For 5-second timer
    let generator = UIImpactFeedbackGenerator(style: .heavy)

    var body: some View {
        VStack(spacing: 16) {
            Text("Upload a front selfie")
                .font(.title2)
                .bold()

            // Image or Camera View
            ZStack {
                if showCamera {
                    CameraView(cameraModel: cameraModel, onPhotoTaken: {
                        captureWithTimerIfNeeded()
                    })
                } else {
                    DefaultImageView(defaultImage: defaultImage)
                }
            }
            .frame(width: 275, height: 445) // Consistent dimensions
            .cornerRadius(20)

            if showCamera {
                VStack(spacing: 10) {
                    // Switch Camera and Timer HStack
                    HStack {
                        Button(action: {
                            cameraModel.toggleCamera() // Toggle between front/back cameras
                        }) {
                            Text("Switch Camera")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.purple)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        
                        Button(action: {
                            isTimerEnabled.toggle()
                        }) {
                            Text(isTimerEnabled ? "Timer On" : "Timer Off")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(isTimerEnabled ? Color.green : Color.purple)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                    .padding(.bottom, 10) // Space above "Take Picture" button
                    
                    // Take Picture Button
                    cameraCaptureButton
                }
            } else if let _ = defaultImage {
                buttonGroupForDefaultImage // "Choose Another" and "Continue"
            } else {
                actionButton // "Upload or take selfie"
            }

            Spacer()
        }
        .padding()
        .onChange(of: cameraModel.capturedImage) { _, newImage in
            handleCapturedImage(newImage)
        }
        .onChange(of: photosPickerItem) { _, _ in
            handlePhotoPicker()
        }
        .onDisappear {
            if showCamera {
                cameraModel.stopSession()
            }
        }
        .photosPicker(isPresented: $showPicker, selection: $photosPickerItem)
    }

    // MARK: - Subviews

    private var actionButton: some View {
        Button(action: {
            showOptionsMenu = true
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
    }

    private var buttonGroupForDefaultImage: some View {
        VStack(spacing: 10) {
            Button(action: {
                showOptionsMenu = true
            }) {
                Text("Choose Another")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .foregroundColor(.black)
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

            Button(action: {
                // Add your custom logic for "Continue" here
            }) {
                Text("Continue")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.purple)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
    }

    private var cameraCaptureButton: some View {
        Button(action: {
            captureWithTimerIfNeeded()
        }) {
            Text("Take Picture")
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.purple)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
        .padding()
    }

    // MARK: - Handlers

    private func captureWithTimerIfNeeded() {
        if isTimerEnabled {
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                cameraModel.capturePhoto()
                generator.impactOccurred()
            }
        } else {
            cameraModel.capturePhoto()
            generator.impactOccurred()
        }
    }

    private func handleCapturedImage(_ image: UIImage?) {
        if let image = image, let previewLayer = cameraModel.previewLayer {
            let croppedImage = image.cropToMatchPreview(previewLayer: previewLayer)
            defaultImage = croppedImage ?? image
            viewModel.frontImage = croppedImage ?? image
            cameraModel.stopSession()
            showCamera = false
        }
    }

    private func handlePhotoPicker() {
        Task {
            if let photosPickerItem,
               let data = try? await photosPickerItem.loadTransferable(type: Data.self),
               let image = UIImage(data: data) {
                defaultImage = image
                viewModel.frontImage = image
            }
        }
    }
}

// MARK: - CameraView Component

struct CameraView: View {
    @ObservedObject var cameraModel: CameraModel
    let onPhotoTaken: () -> Void

    var body: some View {
        VStack {
            CameraPreview(cameraModel: cameraModel)
                .scaledToFill()
                .frame(width: 275, height: 445)
                .cornerRadius(20)
                .clipped()
        }
    }
}

// MARK: - DefaultImageView Component

struct DefaultImageView: View {
    let defaultImage: UIImage?

    var body: some View {
        Image(uiImage: defaultImage ?? UIImage(named: "scanImage")!)
            .resizable()
            .scaledToFill()
            .frame(width: 275, height: 445)
            .cornerRadius(20)
            .clipped()
    }
}

