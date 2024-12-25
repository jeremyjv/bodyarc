//
//  FrameView.swift
//  sideprojectgg
//
//  Created by Jeremy Villanueva on 12/13/24.
//
import SwiftUI

struct CustomCameraView: View {
    @StateObject private var cameraModel = CameraModel()
    var body: some View {
        ZStack {
            // Camera Preview
            CameraPreview(cameraModel: cameraModel)
                .ignoresSafeArea() // Ensure it fills the screen

            VStack {
                Spacer()

                // Capture Photo Button
                Button(action: {
                    
                    //set timer
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                        //set countdown timer on screen
                        // Your code to execute after 3 seconds
                        cameraModel.capturePhoto()
                    }
                    //set timer
                    
                    //navigate to next capture view
                    
                    
                }) {
                    Circle()
                        .stroke(Color.white, lineWidth: 4)
                        .frame(width: 75, height: 75)
                }
                .padding(.bottom)
            }
        }
        .onAppear {
            // Check camera authorization and setup
            cameraModel.checkAuthorization()
        }
        .onDisappear {
            cameraModel.session.stopRunning() // Stop the session when the view disappears
        }
    }
}
