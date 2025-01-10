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
    

    // just do a (while) front image == nil -> loading and you're good
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
                            SecondRatingView(frontImage: frontImage, scanObject: scanObject)
                                .tag(1)
                            
                            // Second Slide
                            ThirdRatingView(frontImage: frontImage, scanObject: scanObject)
                                .tag(2)
                            
                            FirstBackRatingView(backImage: backImage, scanObject: scanObject)
                                .tag(3)
                            
                            SecondBackRatingView(backImage: backImage, scanObject: scanObject)
                                .tag(4)
                        }
                        .tabViewStyle(.page(indexDisplayMode: .never))
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top) // Ensures TabView fills the screen
                        .padding(.bottom, -80)
                        

                        // Custom Dots
                        HStack(spacing: 8) {
                            ForEach(0..<4) { index in // Adjust the number of pages
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

struct ProgressBar: View {
    var score: Int

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Background bar
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 12) // Adjust height here

                // Foreground bar
                RoundedRectangle(cornerRadius: 10)
                    .fill(colorForScore(score: score))
                    .frame(width: CGFloat(score) / 100.0 * geometry.size.width, height: 12) // Adjust height here
            }
        }
        .frame(width: 120, height: 12) // Set the width to a shorter value (e.g., 100) // Set the fixed height of the ProgressBar
    }

    func colorForScore(score: Int) -> Color {
        let normalizedScore = Double(score) / 100.0
        let red = (1.0 - normalizedScore) * 0.7 + 0.3 // Scale down red and blend with white
        let green = normalizedScore * 0.7 + 0.3       // Scale down green and blend with white
        let blue = 0.2                                // Keep blue constant for pastel look
        return Color(red: red, green: green, blue: blue)
    }
}

#Preview {
    
}
