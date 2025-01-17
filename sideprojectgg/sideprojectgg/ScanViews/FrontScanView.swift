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
    @State private var cameraModel = CameraModel()
    @State private var showCamera: Bool = false
    @State private var defaultImage: UIImage?
    @State private var photosPickerItem: PhotosPickerItem?
    @State private var showPicker: Bool = false
    @State private var showOptionsMenu: Bool = false
    @State private var isTimerEnabled: Bool = false // For 5-second timer
    
    @State private var isCountdownActive: Bool = false
    @State private var countdownValue: Int = 5
    let generator = UIImpactFeedbackGenerator(style: .heavy)
    
    @Binding var path: NavigationPath
    
    private let screenWidth = UIScreen.main.bounds.width
    private var previewWidth: CGFloat {
        screenWidth * 0.9 // 90% of the screen width
    }
    private var previewHeight: CGFloat {
        previewWidth * 4 / 3 // Aspect ratio of 4:3 (common for cameras)
    }

    var body: some View {
        VStack(spacing: 16) {
            Text("Upload a front selfie")
                .font(.title2)
                .bold()

            // Image or Camera View
            ZStack {
                if showCamera {
                    CameraView(
                        cameraModel: cameraModel,
                        onPhotoTaken: {
                            captureWithTimerIfNeeded()
                        },
                        isCountdownActive: $isCountdownActive,
                        countdownValue: $countdownValue,
                        width: previewWidth,
                        height: previewHeight
                    )
                    .transition(.opacity) // Smooth fade-in
                } else {
                    DefaultImageView(defaultImage: defaultImage, width: previewWidth, height: previewHeight)
                }
            }
            .frame(width: previewWidth, height: previewHeight) // Consistent dimensions
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
        .onReceive(cameraModel.$capturedImage) { newImage in
            if let newImage = newImage {
                handleCapturedImage(newImage)
            }
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
                withAnimation {
                        showCamera = true
                    }
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
                    withAnimation {
                            showCamera = true
                        }
                }
                Button("Upload from Photo Library") {
                    showPicker = true
                }
                Button("Cancel", role: .cancel) {}
            }

            Button(action: {
                path.append("BackScanView")
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
            Text(isCountdownActive ? "Taking Photo..." : "Take Picture")
                .frame(maxWidth: .infinity)
                .padding()
                .background(isCountdownActive ? Color.gray : Color.purple)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
        .disabled(isCountdownActive) // Disable button during countdown
        .padding()
    }
    
    private var countdownOverlay: some View {
        Group {
            if isCountdownActive {
                Text("\(countdownValue)")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)
                    .padding()
                    .background(Circle().fill(Color.black.opacity(0.7)))
                    .frame(width: 80, height: 80)
                    .animation(.easeInOut, value: countdownValue)
                    .transition(.opacity)
            }
        }
    }

    // MARK: - Handlers

    private func captureWithTimerIfNeeded() {
        if isTimerEnabled {
            isCountdownActive = true
            countdownValue = 5
            
            // Start the countdown
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                countdownValue -= 1
                if countdownValue <= 0 {
                    timer.invalidate()
                    isCountdownActive = false
                    cameraModel.capturePhoto()
                    generator.impactOccurred()
                }
            }
        } else {
            cameraModel.capturePhoto()
            generator.impactOccurred()
        }
    }

    private func handleCapturedImage(_ image: UIImage?) {
        if let image = image, let previewLayer = cameraModel.previewLayer {
            // Crop the image to match the preview's visible area
            let croppedImage = image.cropToMatchPreview(previewLayer: previewLayer)
            
            // Flip the image horizontally only if using the front-facing camera
            let finalImage: UIImage?
            if cameraModel.isUsingFrontCamera {
                finalImage = croppedImage?.flippedHorizontally() ?? croppedImage ?? image
            } else {
                finalImage = croppedImage ?? image
            }

            // Update the default image and view model with the processed image
            defaultImage = finalImage
            viewModel.frontImage = finalImage

            // Stop the camera session and close the camera view
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
                
                // Crop the image to match the preview dimensions
                if let croppedImage = cropImageToPreviewDimensions(image: image, previewWidth: previewWidth, previewHeight: previewHeight) {
                    viewModel.frontImage = croppedImage
                } else {
                    // Fallback in case cropping fails
                    defaultImage = image
                    viewModel.frontImage = image
                }
            }
        }
    }
    
    private func cropImageToPreviewDimensions(image: UIImage, previewWidth: CGFloat, previewHeight: CGFloat) -> UIImage? {
        // Calculate the target aspect ratio (4:3 in this case)
        let targetAspectRatio = previewWidth / previewHeight
        
        guard let cgImage = image.cgImage else { return nil }
        
        let originalWidth = CGFloat(cgImage.width)
        let originalHeight = CGFloat(cgImage.height)
        let originalAspectRatio = originalWidth / originalHeight
        
        var cropRect: CGRect
        
        // Determine the cropping rectangle
        if originalAspectRatio > targetAspectRatio {
            // Image is wider than target, crop the sides
            let newWidth = originalHeight * targetAspectRatio
            cropRect = CGRect(
                x: (originalWidth - newWidth) / 2,
                y: 0,
                width: newWidth,
                height: originalHeight
            )
        } else {
            // Image is taller than target, crop the top and bottom
            let newHeight = originalWidth / targetAspectRatio
            cropRect = CGRect(
                x: 0,
                y: (originalHeight - newHeight) / 2,
                width: originalWidth,
                height: newHeight
            )
        }
        
        // Perform cropping
        guard let croppedCGImage = cgImage.cropping(to: cropRect) else { return nil }
        
        // Convert cropped CGImage back to UIImage
        return UIImage(cgImage: croppedCGImage, scale: image.scale, orientation: image.imageOrientation)
    }
}

// MARK: - CameraView Component

struct CameraView: View {
    @ObservedObject var cameraModel: CameraModel
    let onPhotoTaken: () -> Void
    @Binding var isCountdownActive: Bool
    @Binding var countdownValue: Int
    
    let width: CGFloat
    let height: CGFloat

    var body: some View {
        ZStack {
            CameraPreview(cameraModel: cameraModel)
                .scaledToFill()
                .frame(width: width, height: height) // Use passed dimensions
                .cornerRadius(20)
                .clipped()
            
            if isCountdownActive {
                Text("\(countdownValue)")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)
                    .padding()
                    .background(Circle().fill(Color.black.opacity(0.7)))
                    .frame(width: 80, height: 80)
            }
        }
    }
}

// MARK: - DefaultImageView Component

struct DefaultImageView: View {
    let defaultImage: UIImage?
    let width: CGFloat
    let height: CGFloat

    var body: some View {
        Image(uiImage: defaultImage ?? UIImage(named: "scanImage")!)
            .resizable()
            .scaledToFill()
            .frame(width: width, height: height) // Use passed dimensions
            .cornerRadius(20)
            .clipped()
    }
}

