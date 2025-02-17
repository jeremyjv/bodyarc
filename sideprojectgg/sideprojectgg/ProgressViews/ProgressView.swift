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
    
    let generator = UIImpactFeedbackGenerator(style: .heavy)
    


    func loadData() async {
        do {
            scans = try await viewModel.fetchScanObjects()
            guard let fetchedScans = scans else { return }

            let sortedScans = fetchedScans.sorted { ($0.createdAt ?? Date.distantPast) > ($1.createdAt ?? Date.distantPast) }

            DispatchQueue.main.async {
                self.scans = sortedScans
                self.retrievedScanImages = Array(repeating: [nil], count: sortedScans.count) // Default to front image only
            }

            try await withThrowingTaskGroup(of: (Int, [UIImage?]).self) { group in
                for (index, scan) in sortedScans.enumerated() {
                    group.addTask {
                        var images: [UIImage?] = []

                        if let frontImageURL = scan.frontImage {
                            images.append(try await viewModel.loadImage(from: frontImageURL))
                        }

                        if let backImageURL = scan.backImage {
                            images.append(try await viewModel.loadImage(from: backImageURL))
                        }

                        return (index, images)
                    }
                }

                for try await (index, images) in group {
                    DispatchQueue.main.async {
                        self.retrievedScanImages[index] = images
                        if retrievedScanImages.filter({ !$0.isEmpty }).count == sortedScans.count {
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
        ZStack {
            Color(red: 15/255, green: 15/255, blue: 15/255)
                .edgesIgnoringSafeArea(.all)

            VStack(alignment: .leading, spacing: 10) { // Ensure spacing is zero to keep structure intact
                // Keep the title pinned to the top
                VStack(alignment: .leading) {
                    Text("Progress")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .padding(.top, 20)  // Match RoutineView's top padding
                        .bold()
                        .padding(.horizontal)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(red: 15/255, green: 15/255, blue: 15/255)) // Ensures background matches
                
                Button(action: {
                    generator.impactOccurred()
                    path.append("DailyProgressPicturesView")
                }) {
                    HStack {
                        Spacer()
                        VStack(alignment: .center, spacing: 8) {
                            Text("Take daily progress pictures")
                                .font(.headline)
                                .foregroundColor(.white)
                                .bold()
            
                        }
    
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.white)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, minHeight: 130)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.horizontal)
                
                Spacer()
                    .frame(height: 20)
                
                
                Text("Your Ratings")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .bold()
                    .padding(.horizontal)
                // Scrollable content
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        if loadingScreen {
                            VStack {
                               Spacer() // Pushes text downward
                               Text("Loading...")
                                   .foregroundColor(.white)
                                   .font(.title2)
                                   .bold()
                                   .multilineTextAlignment(.center)
                               Spacer() // Pushes text upward
                           }
                           .frame(maxWidth: .infinity, minHeight: 400) // Ensures a minimum height for centering
                        } else if viewModel.isScanProcessing && viewModel.scans!.isEmpty {
                            VStack(spacing: 20) {
                                Text("Please do not close the app, you may risk losing your scan")
                                    .font(.headline)
                                    .foregroundColor(.blue)
                                LoadingCardView(
                                    frontImage: viewModel.frontImage,
                                    backImage: viewModel.backImage
                                )
                            }
                            .padding()
                        } else if viewModel.scans!.isEmpty {
                            VStack {

                                Button(action: {
                                    generator.impactOccurred() // Haptic feedback
                                    path.append("FrontInstructionsView") // Navigate to FrontInstructionsView
                                }) {
                                    HStack {
                                        Spacer()
                                        VStack(alignment: .leading, spacing: 8) {
                                            Text("Scan to get your ratings")
                                                .font(.headline)
                                                .foregroundColor(.white)
                                                .bold()
                            
                                        }
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(.white)
                                    }
                                    .padding()
                                    .frame(height: 130)
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(12)
                                    .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                                }
                                .buttonStyle(PlainButtonStyle())
                                .padding(.horizontal)

                                Spacer()
                            }
                            .frame(maxWidth: .infinity, minHeight: 400)
                        } else {
                            LazyVStack(alignment: .leading, spacing: 20) {
                                if viewModel.isScanProcessing {
                                    Text("Please do not close the app, you may risk losing your scan")
                                        .font(.headline)
                                        .foregroundColor(.blue)
                                        .padding(.bottom, 10)
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
                            .padding(.horizontal)
                        }
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
                VStack(alignment: .leading, spacing: 8) {
                    Text(scan.createdAt?.formattedDateString() ?? "Unknown Date")
                        .font(.headline)
                        .foregroundColor(.white)
                    Text("View Results")
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .bold()
                }

                Spacer()

                HStack(spacing: 10) {
                    if images.count == 1 { // Only front image exists
                        if let frontImage = images.first ?? nil {
                            Image(uiImage: frontImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 90, height: 110)
                                .cornerRadius(8)
                        } else {
                            Color.gray.opacity(0.3)
                                .frame(width: 90, height: 110)
                                .cornerRadius(8)
                        }
                    } else { // Both front and back images exist
                        if let frontImage = images.first ?? nil {
                            Image(uiImage: frontImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 90, height: 110)
                                .cornerRadius(8)
                        } else {
                            Color.gray.opacity(0.3)
                                .frame(width: 90, height: 110)
                                .cornerRadius(8)
                        }

                        if images.count > 1, let backImage = images[1] {
                            Image(uiImage: backImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 90, height: 110)
                                .cornerRadius(8)
                        }
                    }
                }
                .frame(maxWidth: images.count == 1 ? .infinity : nil, alignment: images.count == 1 ? .center : .leading) // Center when single image
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
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
                        .frame(width: 90, height: 110)
                        .cornerRadius(8)
                } else {
                    Color.gray.opacity(0.3)
                        .frame(width: 90, height: 110)
                        .cornerRadius(8)
                }

                // Back Image (Optional)
                if let backImage = backImage {
                    Image(uiImage: backImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 90, height: 110)
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
