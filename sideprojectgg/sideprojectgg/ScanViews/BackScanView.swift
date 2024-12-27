//
//  BackViewScan.swift
//  sideprojectgg
//
//  Created by Jeremy Villanueva on 12/26/24.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseFunctions
import PhotosUI

struct BackScanView: View {
    @StateObject private var viewModel = ContentViewModel()
    
    @State private var defaultImage: UIImage?
    @State private var photosPickerItem: PhotosPickerItem?
    @State private var analysis: String?

    

    var body: some View {
        
        VStack(spacing: 16) {
            // Top Rectangle
            RectangleComponent()
                .frame(height: 50) // Adjust height as per your mockup
            
            Text( "Upload Image of Back")
            
            // Middle Rectangle
            Image(uiImage: defaultImage ?? UIImage(named: "scanImage")!)
                .resizable()
                .scaledToFill()
                .frame(width: 300, height: 300)
            
            Text( "Analysis: \(viewModel.text)") // Display the result if it exists
            //Select Photo from camera roll
            
            
            //replace these blocks of code with "Scan" and redirect to FrontViewScan
            PhotosPicker(selection: $photosPickerItem, matching: .images) {
                Text("-Upload Image-")
            }
            NavigationLink(destination: FrontCameraView()
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
    ContentView()
}
