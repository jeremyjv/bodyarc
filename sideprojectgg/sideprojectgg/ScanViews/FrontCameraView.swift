//
//  FrontCameraView.swift
//  sideprojectgg
//
//  Created by Jeremy Villanueva on 12/26/24.
//

import SwiftUI

struct FrontCameraView: View {
    @StateObject private var cameraModel = CameraModel()
    
    
    var body: some View {
        ZStack {
            // Camera Preview
            CameraPreview(cameraModel: cameraModel)
                .ignoresSafeArea() // Ensure it fills the screen
            
            
            VStack {
                
                NavigationLink(destination: BackScanView()){
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
            cameraModel.checkAuthorization()
        }
        .onDisappear {
            cameraModel.session.stopRunning() // Stop the session when the view disappears
            
        }
    }
}
