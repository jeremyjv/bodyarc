//
//  FrontCameraView.swift
//  sideprojectgg
//
//  Created by Jeremy Villanueva on 12/26/24.
//

import SwiftUI


struct FrontCameraView: View {
    @ObservedObject var cameraModel: CameraModel
    @Binding var path: NavigationPath
    
    
    var body: some View {
        ZStack {
            // Camera Preview
            CameraPreview(cameraModel: cameraModel)
                .ignoresSafeArea() // Ensure it fills the screen
            
            // add a processing screen while front image is updating
            VStack {
                //instead of navigating just remove
                
                Button(action: {
                    cameraModel.toggleCamera()
                }) {
                    Text("Toggle Front/Back Camera")
                }
                Spacer()
                Button(action: {
                   
                    path.removeLast()
                    cameraModel.capturePhoto()

                
                }){
                    Circle()
                        .stroke(Color.white, lineWidth: 4)
                        .frame(width: 75, height: 75)
                }

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
