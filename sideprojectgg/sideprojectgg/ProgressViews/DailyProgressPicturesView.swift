//
//  DailyProgressPictureView.swift
//  Body Arc
//
//  Created by Jeremy Villanueva on 2/17/25.
//

import SwiftUI
import FirebaseFunctions
import FirebaseFirestore

struct DailyProgressPicturesView: View {
    @EnvironmentObject var viewModel: ContentViewModel
        @Binding var path: NavigationPath

        @State private var retrievedProgressImages: [[UIImage?]] = []
        @State private var loadingScreen = true
        @State private var hasLoadedData = false
        
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        
    func loadData() async {
        do {
            viewModel.progressPhotos = try await fetchProgressPhotos()
            guard let fetchedPhotos = viewModel.progressPhotos else {
                self.loadingScreen = false
                return
            }
            
            let sortedPhotos = fetchedPhotos.sorted { ($0.createdAt ?? Date.distantPast) > ($1.createdAt ?? Date.distantPast) }
            
            DispatchQueue.main.async {
                viewModel.progressPhotos = sortedPhotos
                viewModel.retrievedProgressImages = Array(repeating: [nil, nil], count: sortedPhotos.count)
            }
            
            // Load images for each progress photo
            try await withThrowingTaskGroup(of: (Int, [UIImage?]).self) { group in
                for (index, photo) in sortedPhotos.enumerated() {
                    group.addTask {
                        var images: [UIImage?] = []
                        
                        if let frontImageURL = photo.frontImage {
                            images.append(try await viewModel.loadImage(from: frontImageURL))
                        }
                        
                        if let backImageURL = photo.backImage {
                            images.append(try await viewModel.loadImage(from: backImageURL))
                        }
                        
                        return (index, images)
                    }
                }
                
                for try await (index, images) in group {
                    DispatchQueue.main.async {
                        if index < viewModel.retrievedProgressImages.count {
                            viewModel.retrievedProgressImages[index] = images
                        }
                    }
                }
            }
            
            DispatchQueue.main.async {
                self.loadingScreen = false
            }
        } catch {
            print("Error fetching progress photos: \(error)")
            self.loadingScreen = false
        }
    }
        
        var body: some View {
            ZStack {
                Color(red: 15/255, green: 15/255, blue: 15/255)
                    .edgesIgnoringSafeArea(.all)
                VStack(alignment: .leading) {
                    Text("Daily Progress")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .bold()
                        .padding()
                    
                    ScrollView {
                        if loadingScreen {
                            VStack {
                                Text("Loading...")
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                            }
                        } else if let photos = viewModel.progressPhotos, !photos.isEmpty {
                            LazyVStack(spacing: 20) {
                                ForEach(Array(zip(photos.indices, photos)), id: \.0) { index, photo in
                                    if index < viewModel.retrievedProgressImages.count,
                                       let frontImage = viewModel.retrievedProgressImages[index].first {
                                        ProgressPhotoCard(
                                            photo: photo,
                                            frontImage: frontImage!,
                                            backImage: viewModel.retrievedProgressImages[index].count > 1 ? viewModel.retrievedProgressImages[index][1] : nil
                                        )
                                        .padding(.horizontal)
                                    }
                                }
                            }
                        } else {
                            VStack {
                                Text("Upload your first Progress Pictures")
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(12)
                                    .padding()
                            }
                        }
                    }
                }
                
                // Add button
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            generator.impactOccurred()
                            path.append("FrontProgressScanView")
                        }) {
                            Image(systemName: "plus")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(width: 80, height: 80)
                                .background(Color.blue)
                                .clipShape(Circle())
                                .shadow(radius: 4)
                        }
                        .padding(.trailing, 30)
                        .padding(.bottom, 30)
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
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        path.removeLast()
                        generator.impactOccurred()
                    }) {
                        HStack {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.gray) // Set the color to gray
                        }
                    }
                }
            }
        }
    
    
    func fetchProgressPhotos() async throws -> [ProgressPhotos] {
        let db = Firestore.firestore()
        return try await withCheckedThrowingContinuation { continuation in
            db.collection("progress")
                .whereField("userUID", isEqualTo: viewModel.uid as Any)
                .getDocuments { snapshot, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                    } else if let snapshot = snapshot {
                        let progressPhotos: [ProgressPhotos] = snapshot.documents.compactMap { doc in
                            try? doc.data(as: ProgressPhotos.self) // Decode Firestore documents into `ScanObject`
                        }
                        continuation.resume(returning: progressPhotos)
                    } else {
                        continuation.resume(returning: [])
                    }
                }
        }
    }
}

struct ProgressPhotoCard: View {
    let photo: ProgressPhotos
    let frontImage: UIImage
    let backImage: UIImage?
    let generator = UIImpactFeedbackGenerator(style: .heavy)
    
    var body: some View {
        VStack(spacing: 10) {
            HStack(spacing: 10) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(photo.createdAt?.formattedDateString() ?? "Unknown Date")
                        .font(.headline)
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                HStack(spacing: 10) {
                    Image(uiImage: frontImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 90, height: 110)
                        .cornerRadius(8)
                    
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
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
        }
    }
}
