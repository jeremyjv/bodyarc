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
    
    //for scan prompt : if viewModel.scans.count == 0 ----> direct them to scan

    func loadData() async {
        do {
            scans = try await viewModel.fetchScanObjects()
            
            guard let fetchedScans = scans else { return }
            
            // Sort scans by `createdAt` in descending order (most recent first)
            let sortedScans = fetchedScans.sorted { ($0.createdAt ?? Date.distantPast) > ($1.createdAt ?? Date.distantPast) }
            
            DispatchQueue.main.async {
                self.scans = sortedScans
                self.retrievedScanImages = Array(repeating: [nil, nil], count: sortedScans.count)
            }

            try await withThrowingTaskGroup(of: (Int, [UIImage?]).self) { group in
                for (index, scan) in sortedScans.enumerated() {
                    group.addTask {
                        var frontImage: UIImage? = nil
                        var backImage: UIImage? = nil

                        if let frontImageURL = scan.frontImage {
                            frontImage = try await viewModel.loadImage(from: frontImageURL)
                        }

                        if let backImageURL = scan.backImage {
                            backImage = try await viewModel.loadImage(from: backImageURL)
                        }

                        return (index, [frontImage, backImage])
                    }
                }

                for try await (index, images) in group {
                    DispatchQueue.main.async {
                        self.retrievedScanImages[index] = images
                        if retrievedScanImages.filter({ $0 != [nil, nil] }).count == sortedScans.count {
                            self.loadingScreen = false
                        }
                    }
                }
                self.loadingScreen = false
            }
        } catch {
            print("Error fetching scan objects: \(error)")
        }
    }

    var body: some View {
        VStack(alignment: .leading) {
            
                Text("Your Progress")
                    .font(.largeTitle)
                    .bold()
                    .padding()
                
                
                if loadingScreen {
                    Text("Loading...")
                } else if viewModel.isScanProcessing && viewModel.scans!.count == 0 {
                    // Show the loading card when a scan is in progress
                    
                    ScrollView {
                        LazyVStack(spacing: 20) {
                            
                            LoadingCardView(
                                frontImage: viewModel.frontImage,
                                backImage: viewModel.backImage
                            )
                        }
                    }
                } else if viewModel.scans!.count == 0 {
                    
                    Text("Scan to get your ratings")
                } else {
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 20) {
                            
                            
                            if viewModel.isScanProcessing {
                                    LoadingCardView(
                                        frontImage: viewModel.frontImage,
                                        backImage: viewModel.backImage
                                    )
                                }
                            
                            ForEach(retrievedScanImages.indices, id: \.self) { index in
                                if let scan = scans?[index] {
                                    ProgressCardView(
                                        scan: scan,
                                        images: retrievedScanImages[index],
                                        path: $path
                                    )
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
                    Task { await loadData() }
                }
            }
        }
}
    
struct ProgressCardView: View {
    let scan: ScanObject
    let images: [UIImage?]
    @Binding var path: NavigationPath
    let generator = UIImpactFeedbackGenerator(style: .heavy)

    var body: some View {
        Button(action: {
            path.append(scan) // Append the scan to the navigation path
            generator.impactOccurred()
        }) {
            HStack(spacing: 10) {
                // Date and Button (Left Side)
                VStack(alignment: .leading, spacing: 8) {
                    Text(scan.createdAt?.formattedDateString() ?? "Unknown Date")
                        .font(.headline)
                        .foregroundColor(.white) // Ensure text is visible on dark background
                    Text("View Results ->")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }

                Spacer()

                // Front and Back Images (Right Side)
                HStack(spacing: 10) {
                    // Front Image
                    if let frontImage = images[0] {
                        Image(uiImage: frontImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 100)
                            .cornerRadius(8)
                    } else {
                        Color.gray.opacity(0.3)
                            .frame(width: 80, height: 100)
                            .cornerRadius(8)
                    }

                    // Back Image
                    if let backImage = images[1] {
                        Image(uiImage: backImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 100)
                            .cornerRadius(8)
                    } else {
                        Color.gray.opacity(0.3)
                            .frame(width: 80, height: 100)
                            .cornerRadius(8)
                    }
                }
            }
            .padding()
            .background(Color.gray.opacity(0.2)) // Dark gray background
            .cornerRadius(12) // Rounded corners
            .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2) // Optional: Add subtle shadow for depth
        }
        .buttonStyle(PlainButtonStyle()) // Use a plain button style to remove the default button appearance
    }
}

struct LoadingCardView: View {
    let frontImage: UIImage?
    let backImage: UIImage?

    var body: some View {
        HStack(spacing: 10) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Processing Scan...")
                    .font(.headline)
                    .foregroundColor(.white)
                Text("This may take a few moments.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }

            Spacer()

            HStack(spacing: 10) {
                // Front Image
                if let frontImage = frontImage {
                    Image(uiImage: frontImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 100)
                        .cornerRadius(8)
                } else {
                    Color.gray.opacity(0.3)
                        .frame(width: 80, height: 100)
                        .cornerRadius(8)
                }

                // Back Image
                if let backImage = backImage {
                    Image(uiImage: backImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 100)
                        .cornerRadius(8)
                } else {
                    Color.gray.opacity(0.3)
                        .frame(width: 80, height: 100)
                        .cornerRadius(8)
                }
            }
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
    }
}


extension Date {
    func formattedDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: self)
    }
}
