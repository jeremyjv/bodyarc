//
//  RatingView.swift
//  sideprojectgg
//
//  Created by Jeremy Villanueva on 1/6/25.
//

import SwiftUI
import FirebaseFirestore


//we mount analysis data here


struct RatingView: View {
    //attach rating to this view
    @EnvironmentObject var viewModel: ContentViewModel
    var scanObject: ScanObject
    @State private var frontImage: UIImage? = nil
    @State private var backImage: UIImage? = nil
    @Binding var path: NavigationPath
    
    @State private var isLoading = true // State to track loading
    

    
    var body: some View {
        ZStack {
               
            if let image = frontImage {
                   Image(uiImage: image)
                       .resizable()
                       .scaledToFill() // Ensures the image fills the screen
                       .frame(maxWidth: .infinity, maxHeight: .infinity) // Fills the available space
                       .overlay(
                           Color.black.opacity(0.9) // Apply a semi-transparent black overlay
                               .edgesIgnoringSafeArea(.all)
                       ) // Darkens the image
                       .edgesIgnoringSafeArea(.all) // Ensures it extends under safe areas
                
                
                
               } else {
                   // Placeholder loading image or view
                   VStack {
                       Text("Fetching Image...")
                           .font(.subheadline)
                           .foregroundColor(.gray)
                   }
                   .frame(maxWidth: .infinity, maxHeight: .infinity) // Fills the available space
                   .background(Color.black.edgesIgnoringSafeArea(.all)) // Background for placeholder
               }
            }
                
            .onAppear {
                // Fetch the front image
                Task {
                    if scanObject.frontImage != nil {
                        do {
                            frontImage = try await viewModel.loadImage(from: scanObject.frontImage!)
                            isLoading = false // Set loading to false after fetching
                        } catch {
                            print("Failed to fetch front image: \(error)")
                            isLoading = false
                        }
                    }
                    if scanObject.backImage != nil {
                        do {
                            backImage = try await viewModel.loadImage(from: scanObject.backImage!)
                            isLoading = false // Set loading to false after fetching
                        } catch {
                            print("Failed to fetch back image: \(error)")
                            isLoading = false
                        }
                    }
                 
                }
            }
        }
    

   
}

#Preview {
    
}
