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
    
    //to stop reloading routineview all the time
    @State private var hasLoadedData = false
    
    
    

    
    enum Destination: Hashable {
        case string(String)
        case scanObject(ScanObject)
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
                        
                        RoutineView(muscleOrder: viewModel.muscleRankings!).tabItem({
                            Label("Routine", systemImage: "person")
                        })
                       
                        
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
                    .navigationDestination(for: ScanObject.self) { scan in
                        RatingView(scanObject: scan, path: $path)
                    }
                    .gesture(DragGesture().onChanged { _ in })
                    .onAppear {
                        //only obtain user muscle ranking if uid exists
                        if (viewModel.uid != nil && !hasLoadedData) {
                            Task {
                                hasLoadedData = true
                                do {
                                    let db = Firestore.firestore()
                                    let docRef = db.collection("users").document(viewModel.uid!)
                                    
                                    // Fetch the document using the async alternative
                                    let document = try await docRef.getDocument()
                                    
                                    // Check if the document exists
                                    if let documentData = document.data(),
                                       let ranking = documentData["muscleRanking"] as? [String] {
                                        DispatchQueue.main.async {
                                            viewModel.muscleRankings = ranking
                                            print("fetched muscle rankings from user and mounted to routineView")
                                        }
                                    } else {
                                        print("muscleRanking field not found or not an array of strings.")
                                    }
                                } catch {
                                    print("Error fetching muscleRanking: \(error.localizedDescription)")
                                }
                            }
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
