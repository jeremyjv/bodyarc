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
            scans = try await viewModel.fetchScanObjects()
            guard var scans = scans else { return }
            scans.reverse()

            DispatchQueue.main.async {
                self.scans = scans
                self.retrievedScanImages = Array(repeating: [nil, nil], count: scans.count)
            }

            try await withThrowingTaskGroup(of: (Int, [UIImage?]).self) { group in
                for (index, scan) in scans.enumerated() {
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
                        if retrievedScanImages.filter({ $0 != [nil, nil] }).count == scans.count {
                            self.loadingScreen = false
                        }
                    }
                }
            }
        } catch {
            print("Error fetching scan objects: \(error)")
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

    var body: some View {
        HStack(spacing: 10) {
            // Front Image
            Rectangle()
                .fill(images[0] == nil ? Color.gray.opacity(0.3) : Color.white)
                .frame(width: 80, height: 100)
                .overlay {
                    if let frontImage = images[0] {
                        Image(uiImage: frontImage)
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(5)
                    }
                }
                .cornerRadius(8)

            // Back Image
            Rectangle()
                .fill(images[1] == nil ? Color.gray.opacity(0.3) : Color.white)
                .frame(width: 80, height: 100)
                .overlay {
                    if let backImage = images[1] {
                        Image(uiImage: backImage)
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(5)
                    }
                }
                .cornerRadius(8)

            Spacer()

            // Date and Button
            VStack(alignment: .leading, spacing: 8) {
                Text(scan.createdAt?.formattedDateString() ?? "Unknown Date")
                    .font(.headline)
                Button(action: {
                    path.append(scan)
                }) {
                    Text("View Results ->")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
            }
        }
        .padding()
        .background(Color.black.opacity(0.05))
        .cornerRadius(12)
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
