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
    @StateObject private var viewModel = ContentViewModel()
    @ObservedObject var cameraModel: CameraModel
    
    @State private var defaultImage: UIImage?
    @State private var photosPickerItem: PhotosPickerItem?
    @State private var analysis: String?

    var body: some View {
        
        VStack(spacing: 16) {
            // Top Rectangle
            RectangleComponent()

                .frame(height: 50) // Adjust height as per your mockup
            Text("Upload Front Selfie")
            
            // Middle Rectangle
            Image(uiImage: defaultImage ?? UIImage(named: "scanImage")!)
                .resizable()
                .scaledToFill()
                .frame(width: 300, height: 300)
                .onChange(of: cameraModel.capturedImage) {_, _ in
                    Task {
                        defaultImage = cameraModel.capturedImage
                    }
                }
            
    
            //Select Photo from camera roll
            
            
            //replace these blocks of code with "Scan" and redirect to FrontViewScan
            PhotosPicker(selection: $photosPickerItem, matching: .images) {
                Text("-Upload Image-")
            }
            NavigationLink(destination: FrontCameraView(cameraModel: cameraModel)
                .ignoresSafeArea()) {
                Text("Take Photo")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
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
                        await viewModel.imageToAnalysis(img: defaultImage!)
                    }
                }
                photosPickerItem = nil
            }
        }
    
    }

}

#Preview {
    //FrontScanView(cameraModel: _cameraModel)
}

