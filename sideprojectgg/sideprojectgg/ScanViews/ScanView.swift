//
//  ScanView.swift
//  sideprojectgg
//
//  Created by Jeremy Villanueva on 12/29/24.
//


import Foundation
import SwiftUI
import Firebase
import FirebaseFunctions
import PhotosUI
import FirebaseFirestore



struct RectangleComponent: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(Color.gray.opacity(0.3)) // Adjust color and opacity
    }
}


struct ScanView: View {
    @EnvironmentObject var viewModel: ContentViewModel
    @Binding var path: NavigationPath
    
    @State private var defaultImage: UIImage?
    @State private var photosPickerItem: PhotosPickerItem?
    @State private var analysis: String?
    
    @State private var frontImageTest: UIImage?
    
    @State private var scans: [ScanObject]?
    
    @State private var selectedTabIndex: Int = 0
    @State private var hasLoadedData = false
    
    //while these are null keep loading screen
    @State private var retrievedScanImages: [[UIImage?]] = []  // No longer optional

    
    private func loadData() async {
        do {
            // Fetch scan objects
            scans = try await viewModel.fetchScanObjects()
            print("Fetched scans: \(scans?.count ?? 0)")

            // Ensure scans is not nil
            guard let scans = scans else {
                print("No scans available.")
                return
            }

            // Initialize `retrievedScanImages` with placeholders
            DispatchQueue.main.async {
                self.retrievedScanImages = Array(repeating: [nil, nil], count: scans.count)
            }

            // Fetch images for each scan
            for (index, scan) in scans.enumerated() {
                do {
                    // Fetch front image
                    let frontImage: UIImage? = try await {
                        if let frontImageURL = scan.frontImage {
                            return try await viewModel.loadImage(from: frontImageURL)
                        }
                        return nil
                    }()

                    // Fetch back image
                    let backImage: UIImage? = try await {
                        if let backImageURL = scan.backImage {
                            return try await viewModel.loadImage(from: backImageURL)
                        }
                        return nil
                    }()

                    // Update `retrievedScanImages` with the loaded images
                    DispatchQueue.main.async {
                        self.retrievedScanImages[index] = [frontImage, backImage]
                    }
                } catch {
                    print("Error loading images for scan at index \(index): \(error.localizedDescription)")
                    // Update `retrievedScanImages` with nil images in case of an error
                    DispatchQueue.main.async {
                        self.retrievedScanImages[index] = [nil, nil]
                    }
                }
            }
        } catch {
            print("Error fetching scan objects: \(error.localizedDescription)")
        }
    }
    
    
    

    var body: some View {

            
  
            
            VStack(spacing: 10) {
                Button(action: {
                    viewModel.signOut()
                }) {
                    Text("sign out")
                }
                

                TabView(selection: $selectedTabIndex) {
                    ZStack {
                       Image(uiImage: UIImage(named: "scanImage")!)
                           .resizable()
                           .scaledToFill()
                           .frame(width: 320, height: 500)
                           .cornerRadius(30)
                        CustomScanButton(title: "Begin Scan", path: $path)
         
                        }.tag(0)
                    
                    if retrievedScanImages.isEmpty { // Show loading screen while images are being fetched
                        VStack {
                            Text("Please wait while your scans are loading.")
                                .font(.headline)
                                .multilineTextAlignment(.center)
                                .padding()
                        }
                    } else {
                        // Loop through retrievedScanImages to display each pair of images (front and back)
                        ForEach(retrievedScanImages.indices, id: \.self) { index in
                            VStack {
                                if let frontImage = retrievedScanImages[index].first ?? UIImage(named: "scanImage") {
                                    Image(uiImage: frontImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 320, height: 500)
                                        .cornerRadius(30)
                                        .overlay(
                                            Text("Front Image")
                                                .font(.caption)
                                                .padding(6)
                                                .background(Color.black.opacity(0.6))
                                                .foregroundColor(.white)
                                                .cornerRadius(10),
                                            alignment: .bottom
                                        )
                                }
                
                            }
                        }
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                .animation(.default, value: retrievedScanImages) // Animates the TabView as images load
                .onAppear {
                    selectedTabIndex = 0  // Ensure the first tab is selected on app launch
                }
           
        
                Spacer()
                
            
            }
            .padding()
            .onAppear {
                // Ensure the logic only runs once
                if !hasLoadedData {
                    hasLoadedData = true  // Mark as loaded
                    Task {
                        await loadData()  // Fetch data
                    }
                }
            }
            .onChange(of: viewModel.frontImage) {_, _ in
                Task {
                    defaultImage = viewModel.frontImage
                }
            }
            
        }
        
    
}

struct CustomScanButton: View {
    var title: String
    @Binding var path: NavigationPath
    @StateObject private var cameraModel = CameraModel()


    var body: some View {
        
    
        HStack {
            Button(action: {
                path.append("FrontScanView")
            }) {
                Text(title) // Button title
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white) // Text color
            }
            .frame(maxWidth: 300, minHeight: 40) // Set button dimensions
            .padding() // Add padding inside the button
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color(red: 4/255, green: 96/255, blue: 255/255), Color(red: 4/255, green: 180/255, blue: 255/255)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(8) // Rounded corners
            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2) // Shadow
        }
        
    
    }

    
}


    

#Preview {
 
}
