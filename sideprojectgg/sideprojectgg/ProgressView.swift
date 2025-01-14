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

            // Ensure scans is not nil and reverse order
            guard var scans = scans else {
                print("No scans available.")
                return
            }
            scans.reverse() // Reverse the order

            DispatchQueue.main.async {
                self.scans = scans // Update the state with reversed scans
                self.retrievedScanImages = Array(repeating: [nil, nil], count: scans.count)
            }

            // Use ThrowingTaskGroup to fetch images concurrently
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

                            return (index, [frontImage, backImage])
                        } catch {
                            print("Error loading images for scan at index \(index): \(error.localizedDescription)")
                            return (index, [nil, nil]) // Return nils on error
                        }
                    }
                }

                // Dynamically update UI as each task completes
                var completedCount = 0
                for try await (index, images) in group {
                    DispatchQueue.main.async {
                        self.retrievedScanImages[index] = images
                        completedCount += 1
                        // Update loadingScreen based on completed tasks
                        if completedCount == scans.count {
                            self.loadingScreen = false
                        }
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

            if loadingScreen {
                Text("Retrieving scans...")
            } else {
                ScrollView {
                    LazyVStack(spacing: 20) {
                        ForEach(retrievedScanImages.indices.reversed(), id: \.self) { index in
                            HStack(spacing: 20) {
                                if scans?[index].frontImage == nil || scans?[index].backImage == nil {
                                    // Show loading card for scans in progress
                                    VStack {
                                        Text("Loading scan...")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                    .frame(width: 300, height: 200)
                                    .background(Color.gray.opacity(0.3))
                                    .cornerRadius(10)
                                } else {
                                    // Show completed scan
                                    // Front Image Button
                                    if let frontImage = retrievedScanImages[index][0] {
                                        Button(action: {
                                            path.append(scans![index])
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
                                    }

                                    // Back Image Button
                                    if let backImage = retrievedScanImages[index][1] {
                                        Button(action: {
                                            print("Back image button tapped for index \(index)")
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
                                    }
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
