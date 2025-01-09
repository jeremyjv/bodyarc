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
    
    @State private var currentPage = 0 // Track the current page
    @State private var isLoading = true // State to track loading
    

    
    var body: some View {
        ZStack {
                    // Background Image
                    if let image = frontImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .overlay(Color.black.opacity(0.9)) // Darkens the image
                            .edgesIgnoringSafeArea(.all)
                    } else {
                        // Placeholder for when the front image is not loaded
                        Color.black
                            .edgesIgnoringSafeArea(.all)
                    }

                    // TabView with Custom Dots
                    VStack {
                        // TabView Content
                        TabView(selection: $currentPage) {
                            // First Slide
                            FirstRatingView(frontImage: frontImage, scanObject: scanObject)
                                .tag(0)

                            // Second Slide
                            FirstRatingView(frontImage: frontImage, scanObject: scanObject)
                                .tag(1)
                        }
                        .tabViewStyle(.page(indexDisplayMode: .never))
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top) // Ensures TabView fills the screen
                        .padding(.bottom, -80)
                        

                        // Custom Dots
                        HStack(spacing: 8) {
                            ForEach(0..<2) { index in // Adjust the number of pages
                                Circle()
                                    .fill(currentPage == index ? Color.white : Color.gray.opacity(0.5))
                                    .frame(width: 10, height: 10)
                            }
                        }
                        .padding(.bottom, 60)
                    }
                    .edgesIgnoringSafeArea(.all) // Ensures the TabView fills the screen
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

#Preview {
    
}
