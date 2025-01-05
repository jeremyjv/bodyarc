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
                // add a processing screen while back image is updating
                //instead of navigating just remove
                Button(action: {
                    cameraModel.capturePhoto()
                    path.removeLast()
                    
                
                }){
                    Circle()
                        .stroke(Color.white, lineWidth: 4)
                        .frame(width: 75, height: 75)
                }.simultaneousGesture(TapGesture().onEnded {
                    cameraModel.capturePhoto()
        
                    
                    //need to access taken picture cameraModel.capturedImage and set defaultImage in frontScanView to cameraModel.capturedImage
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
