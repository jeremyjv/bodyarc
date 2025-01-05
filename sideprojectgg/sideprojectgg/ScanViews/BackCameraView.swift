//
//  BackCameraView.swift
//  sideprojectgg
//
//  Created by Jeremy Villanueva on 12/26/24.
//

import SwiftUI

struct BackCameraView: View {
    //currently have two separate camera model instances for front and scan.
    @ObservedObject var cameraModel: CameraModel
    @Binding var path: NavigationPath
    
    
    var body: some View {
        ZStack {
            // Camera Preview
            CameraPreview(cameraModel: cameraModel)
                .ignoresSafeArea() // Ensure it fills the screen
            
            
            VStack {
                
                NavigationLink(destination: BackScanView(cameraModel: cameraModel, path: $path)){
                    Circle()
                        .stroke(Color.white, lineWidth: 4)
                        .frame(width: 75, height: 75)
                }.simultaneousGesture(TapGesture().onEnded {
                    cameraModel.capturePhoto()
                    
                    
                })

            }
        }
        .onAppear {
            // Check camera authorization and setup
            print("Camera view appearing...")
                if !cameraModel.session.isRunning {
                    cameraModel.checkAuthorization() // Restart the session if necessary
                }
        }
        .onDisappear {
            cameraModel.stopSession() // Stop the session when the view disappears
            
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
    }
}
