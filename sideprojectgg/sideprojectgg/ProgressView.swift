//
//  ProgressView.swift
//  sideprojectgg
//
//  Created by Jeremy Villanueva on 12/29/24.
//

import SwiftUI

struct ProgressView: View {
    @EnvironmentObject var viewModel: ContentViewModel
    @State private var retrievedScanImages: [[UIImage?]] = []  // No longer optional
    @State private var scans: [ScanObject]?
    @State private var hasLoadedData = false
    
    func loadData() async {
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
        VStack {
            Text("Your Progress")
                .font(.title)
                .padding()
            
            ScrollView {
                LazyVStack(spacing: 20) {
                    ForEach(retrievedScanImages.indices, id: \.self) { index in
                        HStack(spacing: 20) {
                            // Front Image Button
                            if let frontImage = retrievedScanImages[index][0] {
                                Button(action: {
                                    print("Front image button tapped for index \(index)")
                                    // Add your action here
                                }) {
                                    Image(uiImage: frontImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 150, height: 200)
                                        .cornerRadius(10)
                                        .overlay(
                                            Text("Front")
                                                .font(.caption)
                                                .padding(6)
                                                .background(Color.black.opacity(0.6))
                                                .foregroundColor(.white)
                                                .cornerRadius(5),
                                            alignment: .bottomTrailing
                                        )
                                }
                            } else {
                                // Button with a loading view
                                    Button(action: {
                                        print("Loading front image...")
                                    }) {
                                        VStack {
                                            ProgressView()
                                                .frame(width: 50, height: 50)
                                            Text("Loading...")
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                        }
                                        .frame(width: 150, height: 200)
                                        .background(Color.gray.opacity(0.3))
                                        .cornerRadius(10)
                                    }
                            }
                            
                            // Back Image Button
                            if let backImage = retrievedScanImages[index][0] {
                                Button(action: {
                                    print("Back image button tapped for index \(index)")
                                    // Add your action here
                                }) {
                                    Image(uiImage: backImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 150, height: 200)
                                        .cornerRadius(10)
                                        .overlay(
                                            Text("Back")
                                                .font(.caption)
                                                .padding(6)
                                                .background(Color.black.opacity(0.6))
                                                .foregroundColor(.white)
                                                .cornerRadius(5),
                                            alignment: .bottomTrailing
                                        )
                                }
                            } else {
                                Text("No Back Image")
                                    .frame(width: 150, height: 200)
                                    .background(Color.gray.opacity(0.3))
                                    .cornerRadius(10)
                            }
                        }
                    }
                }
                .padding()
            }
        }
        .onAppear {
            if !hasLoadedData {
                hasLoadedData = true
                Task {
                    await loadData()
                }
            }
        }
    }
}
