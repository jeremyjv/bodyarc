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
                Color.black.edgesIgnoringSafeArea(.all)
            }

            VStack {
                // TabView Content
                TabView(selection: $currentPage) {
                    // Always included slides
                    FirstRatingView(frontImage: frontImage, scanObject: scanObject, saveAction: saveScreenshot).tag(0)
                    SecondRatingView(frontImage: frontImage, scanObject: scanObject).tag(1)
                    ThirdRatingView(frontImage: frontImage, scanObject: scanObject).tag(2)

                    // Only include these slides if backAnalysis exists
                    if scanObject.backAnalysis != nil {
                        FirstBackRatingView(backImage: backImage, scanObject: scanObject).tag(3)
                        SecondBackRatingView(backImage: backImage, scanObject: scanObject).tag(4)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .padding(.bottom, -80)

                // Custom Dots
                HStack(spacing: 8) {
                    let totalPages = scanObject.backAnalysis != nil ? 5 : 3
                    ForEach(0..<totalPages, id: \.self) { index in
                        Circle()
                            .fill(currentPage == index ? Color.white : Color.gray.opacity(0.5))
                            .frame(width: 10, height: 10)
                    }
                }
                .padding(.bottom, 50)
            }
            .edgesIgnoringSafeArea(.all)
        }
        .onAppear {
            // Fetch the front image
            Task {
                isLoading = true // Set loading to true at the start
                
                async let frontImageTask: Void = {
                    if let frontImageURL = scanObject.frontImage {
                        do {
                            let image = try await viewModel.loadImage(from: frontImageURL)
                            await MainActor.run {
                                frontImage = image
                            }
                        } catch {
                            print("Failed to fetch front image: \(error)")
                        }
                    }
                }()
                
                async let backImageTask: Void = {
                    if let backImageURL = scanObject.backImage {
                        do {
                            let image = try await viewModel.loadImage(from: backImageURL)
                            await MainActor.run {
                                backImage = image
                            }
                        } catch {
                            print("Failed to fetch back image: \(error)")
                        }
                    }
                }()
                
                // Wait for both tasks to complete
                await frontImageTask
                await backImageTask
                
                await MainActor.run {
                    isLoading = false // Set loading to false after all tasks are complete
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
    
    //captures current view
    var save: some View {
        ZStack {
            if let image = frontImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .overlay(Color.black.opacity(0.9))
                    .edgesIgnoringSafeArea(.all)
            } else {
                Color.black.edgesIgnoringSafeArea(.all)
            }

            VStack {
                if currentPage == 0 {
                    FirstRatingView(frontImage: frontImage, scanObject: scanObject, saveAction: {})
                } else if currentPage == 1 {
                    SecondRatingView(frontImage: frontImage, scanObject: scanObject)
                } else if currentPage == 2 {
                    ThirdRatingView(frontImage: frontImage, scanObject: scanObject)
                }
                // Add extra pages if needed
            }
        }
    }
    
    func saveScreenshot() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            print("Unable to capture screenshot: No active window found")
            return
        }

        // Delay the screenshot to allow UI updates
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let renderer = UIGraphicsImageRenderer(size: window.bounds.size)
            let image = renderer.image { _ in
                window.drawHierarchy(in: window.bounds, afterScreenUpdates: true) // Ensures UI redraw
            }

            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil) // Save to Photos
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
