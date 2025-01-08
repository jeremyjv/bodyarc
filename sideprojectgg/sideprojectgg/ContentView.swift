//
//  ContentView.swift
//  sideprojectgg
//
//  Created by Jeremy Villanueva on 12/2/24.
//
import Foundation
import SwiftUI
import Firebase
import FirebaseFunctions
import PhotosUI





struct ContentView: View {
    
    @EnvironmentObject var viewModel: ContentViewModel
    @State var path = NavigationPath() // To manage navigation
    @StateObject private var cameraModel = CameraModel()
    
    
    //load all necessary data
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
        
        
        if viewModel.isLoggedIn {
          
            NavigationStack(path: $path) {
                    
                    TabView {
                        
                        ScanView(path: $path).tabItem({
                            Label("Scan", systemImage: "magnifyingglass")
                        })
                    
                        ProgressView(retrievedScanImages: $retrievedScanImages, scans: $scans, path: $path).tabItem({
                            Label("Progress", systemImage: "person")
                        })
                        
                        AnalysisView().tabItem({
                            Label("Analysis", systemImage: "magnifyingglass")
                        })
                        
                    }
                    .onAppear {
                        if !hasLoadedData {
                            hasLoadedData = true
                            Task {
                                await loadData()
                            }
                        }
                    }
                    .navigationDestination(for: String.self) { destination in
                        switch destination {
                        case "FrontScanView":
                            FrontScanView(cameraModel: cameraModel, path: $path)
                            
                        case "FrontCameraView":
                            FrontCameraView(cameraModel: cameraModel, path: $path)
                            
                        case "BackScanView":
                            BackScanView(cameraModel: cameraModel, path: $path)
                            
                        case "BackCameraView":
                            BackCameraView(cameraModel: cameraModel, path: $path)
                            
                       
                        
                        //add case for rating view
                                //but need to pass scan object to rating view to mount
                            
                  
                            
                        default:
                            ContentView()
                        }
                        
                    }
                    
                
            }
            
        } else {
            
            //redirect to onboarding if not logged in
            GenderView()
        }
        
        
        // if user is not authed, redirect them to onboard flow
        
     
    }
}
    

#Preview {
    ContentView()
}
