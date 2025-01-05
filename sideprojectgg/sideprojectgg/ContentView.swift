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
    

    var body: some View {
        
        
        if viewModel.isLoggedIn {
        
            
            
            TabView {
                ScanView().tabItem({
                    Label("Scan", systemImage: "magnifyingglass")
                })
                
                ProgressView().tabItem({
                    Label("Progress", systemImage: "person")
                })
                
                AnalysisView().tabItem({
                    Label("Analysis", systemImage: "magnifyingglass")
                })
                
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
