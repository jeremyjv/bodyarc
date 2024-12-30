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
                Label("Home", systemImage: "magnifyingglass")
            })
            
            ProgressView().tabItem({
                Label("Home", systemImage: "person")
            })
        }
    }
}
    

#Preview {
    ContentView()
}
