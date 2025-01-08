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
                    
                        
                        
                        
                        ProgressView().tabItem({
                            Label("Progress", systemImage: "person")
                        })
                        
                        AnalysisView().tabItem({
                            Label("Analysis", systemImage: "magnifyingglass")
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
