//
//  ContentView.swift
//  sideprojectgg
//
//  Created by Jeremy Villanueva on 12/2/24.
//
import Foundation
import SwiftUI
import Firebase
import FirebaseFunctions
import PhotosUI

struct RectangleComponent: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(Color.gray.opacity(0.3)) // Adjust color and opacity
    }
}


struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()
    
    @State private var defaultImage: UIImage?
    @State private var photosPickerItem: PhotosPickerItem?
    @State private var analysis: String?

    

    var body: some View {
        
        VStack(spacing: 16) {
            // Top Rectangle
            RectangleComponent()
                .frame(height: 50) // Adjust height as per your mockup
            
            // Middle Rectangle
            Image(uiImage: UIImage(named: "scanImage")!)
                .resizable()
                .scaledToFill()
                .frame(width: 300, height: 300)
            
            Text( "Analysis: \(viewModel.text)") // Display the result if it exists
            //Select Photo from camera roll
            PhotosPicker(selection: $photosPickerItem, matching: .images) {
                Text("-Upload Image-")
            }
            NavigationLink(destination: CustomCameraView()
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
