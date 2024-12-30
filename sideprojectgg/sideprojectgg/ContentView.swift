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
    
 
    var body: some View {
        
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
    }
}
    

#Preview {
    ContentView()
}
