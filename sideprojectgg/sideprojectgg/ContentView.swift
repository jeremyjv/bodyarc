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
import RevenueCat




struct ContentView: View {
    
    @EnvironmentObject var viewModel: ContentViewModel
    @State var path = NavigationPath() // To manage navigation
    @StateObject private var cameraModel = CameraModel()
    
    

    var body: some View {
        
        
        if viewModel.isLoggedIn {
          
            NavigationStack(path: $path) {
                    
                TabView(selection: $viewModel.selectedTab) {
                        
                        ScanView(path: $path).tabItem({
                            Label("Scan", systemImage: "magnifyingglass")
                        })
                        .tag("ScanView")
                    
                        ProgressView(retrievedScanImages: $viewModel.retrievedScanImages, scans: $viewModel.scans, path: $path).tabItem({
                            Label("Progress", systemImage: "person")
                        })
                        .tag("ProgressView")
                        
                        RoutineView().tabItem({
                            Label("Routine", systemImage: "person")
                        })
                        .tag("RoutineView")
                       
                        
                    }
                    .navigationDestination(for: String.self) { destination in
                        switch destination {
                            
                        case "FrontInstructionsView":
                            FrontInstructionsView(path: $path)
                        
                        case "FrontScanView":
                            FrontScanView(path: $path)
                        
                            
                        case "BackScanView":
                            BackScanView(path: $path)
                            
                        case "BackInstructionsView":
                            BackInstructionsView(path: $path)
                            
            
                        case "PaywallView":
                            PaywallView()
                        case "ScanEdgeView":
                            ScanEdgeView(path: $path)
                                
                        case "InstaScanPaywallView":
                            InstaScanPaywallView(path: $path)
                        case "ProgressView":
                            ProgressView(retrievedScanImages: $viewModel.retrievedScanImages, scans: $viewModel.scans, path: $path)
                        
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
