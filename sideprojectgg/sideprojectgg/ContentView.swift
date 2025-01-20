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
    
    

    var body: some View {
        
        
        if viewModel.isLoggedIn {
          
            NavigationStack(path: $path) {
                    
                    TabView {
                        
                        ScanView(path: $path).tabItem({
                            Label("Scan", systemImage: "magnifyingglass")
                        })
                    
                        ProgressView(retrievedScanImages: $viewModel.retrievedScanImages, scans: $viewModel.scans, path: $path).tabItem({
                            Label("Progress", systemImage: "person")
                        })
                        
                        RoutineView().tabItem({
                            Label("Routine", systemImage: "person")
                        })
                       
                        
                    }
                    .navigationDestination(for: String.self) { destination in
                        switch destination {
                        case "FrontScanView":
                            FrontScanView(path: $path)
                            
                        case "FrontCameraView":
                            FrontCameraView(cameraModel: cameraModel, path: $path)
                            
                        case "BackScanView":
                            BackScanView(path: $path)
                            
                        case "BackCameraView":
                            BackCameraView(cameraModel: cameraModel, path: $path)
                        case "PaywallView":
                            PaywallView()
                        case "ScanEdgeView":
                            ScanEdgeView()
                        case "InstaScanPaywallView":
                            InstaScanPaywallView()
                        
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
                  
                    
                
            }
            
        } else {
            
            //redirect to onboarding if not logged in
            GenderView()
        }
        
       
        
     
    }
}
    

#Preview {
    ContentView()
}
