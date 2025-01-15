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
       
           CameraPreview(cameraModel: cameraModel)
                .cornerRadius(35) // Optional: Add rounded corners
                .frame(maxWidth: .infinity, maxHeight: .infinity) // Directly set frame
               .clipped() // Ensure content doesn't overflow
            
            VStack {
                Button(action: {
                    cameraModel.toggleCamera()
                }) {
                    Text("Toggle Front/Back Camera")
                }
                Spacer()
                Button(action: {
                    path.removeLast()
                    cameraModel.capturePhoto()
                }) {
                    Circle()
                        .stroke(Color.white, lineWidth: 4)
                        .frame(width: 75, height: 75)
                }
            }
        }
        .onAppear {
            print("Camera view appearing...")
            if !cameraModel.session.isRunning {
                cameraModel.checkAuthorization()
            }
        }
        .onDisappear {
            cameraModel.stopSession()
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    path.removeLast()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                    }
                }
            }
        }
    }
}
