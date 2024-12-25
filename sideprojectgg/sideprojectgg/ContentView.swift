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


struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()
    
    @State private var defaultImage: UIImage?
    @State private var photosPickerItem: PhotosPickerItem?
    @State private var analysis: String?

    

    var body: some View {
    
        VStack {


            Text( "Analysis: \(viewModel.text)") // Display the result if it exists
            
            Image(uiImage: defaultImage ?? UIImage(named: "defaultAvatar")!)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 100)
                
            
            //Select Photo from camera roll
            PhotosPicker(selection: $photosPickerItem, matching: .images) {
                Text("-Upload Image-")

            }
            NavigationLink(destination: CustomCameraView()
                .ignoresSafeArea()) {
                Text("Go to Frame View")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
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
