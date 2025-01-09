//
//  ProgressView.swift
//  sideprojectgg
//
//  Created by Jeremy Villanueva on 12/29/24.
//

import SwiftUI

struct ProgressView: View {
    @EnvironmentObject var viewModel: ContentViewModel
 
    
    @Binding var retrievedScanImages: [[UIImage?]]
    @Binding var scans: [ScanObject]?
    @Binding var path: NavigationPath
    @State private var hasLoadedData = false
    @State private var loadingScreen = true
    
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
            
            // Concurrently fetch images for each scan using ThrowingTaskGroup
            try await withThrowingTaskGroup(of: (Int, [UIImage?]).self) { group in
                for (index, scan) in scans.enumerated() {
                    group.addTask {
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
                            
                            // Return the index and fetched images
                            return (index, [frontImage, backImage])
                        } catch {
                            print("Error loading images for scan at index \(index): \(error.localizedDescription)")
                            return (index, [nil, nil]) // Return nils on error
                        }
                    }
                }
                
                // Process the results as they complete
                for try await (index, images) in group {
                    DispatchQueue.main.async {
                        self.retrievedScanImages[index] = images
                    }
                }
                loadingScreen = false
                
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
            
            //To-Do make loading screen more aesthetic
            
            //want it so we show scans in progress after user submits scan
            
            //want loading screen while waiting for retrieved scan images to completely load
            
            
            
            if loadingScreen {
                Text("retrieving scans")
            } else {
                ScrollView {
                    LazyVStack(spacing: 20) {
                        ForEach(retrievedScanImages.indices, id: \.self) { index in
                            HStack(spacing: 20) {
                                // Front Image Button
                                if let frontImage = retrievedScanImages[index][0] {
                                    Button(action: {
                                        path.append(scans![index])
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
