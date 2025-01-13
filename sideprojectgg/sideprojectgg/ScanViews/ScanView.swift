//
//  ScanView.swift
//  sideprojectgg
//
//  Created by Jeremy Villanueva on 12/29/24.
//


import Foundation
import SwiftUI
import Firebase
import FirebaseFunctions
import PhotosUI
import FirebaseFirestore



struct RectangleComponent: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(Color.gray.opacity(0.3)) // Adjust color and opacity
    }
}




struct ScanView: View {
    @EnvironmentObject var viewModel: ContentViewModel
    @Binding var path: NavigationPath
    
    @State private var defaultImage: UIImage?
    @State private var photosPickerItem: PhotosPickerItem?
    @State private var analysis: String?
  
    
    
    

    var body: some View {
        

        VStack(spacing: 10) {
            Button(action: {
                viewModel.signOut()
            }) {
                Text("sign out")
            }
            
            
            
            ZStack {
                Image(uiImage: UIImage(named: "scanImage")!)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 320, height: 520)
                    .cornerRadius(30)
                    .overlay(
                        // Gradient overlay at the bottom
                        LinearGradient(
                            gradient: Gradient(stops: [
                                .init(color: Color.clear, location: 0.65), // Transition starts 70% down
                                .init(color: Color.black, location: 0.85) // Fully black at the bottom
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .cornerRadius(30)
                    )
                CustomScanButton(title: "Begin Scan", path: $path)
                    .offset(y: 200)
                
            }
            
        }
    
        
    }
  
}

struct CustomScanButton: View {
    var title: String
    @Binding var path: NavigationPath
    @StateObject private var cameraModel = CameraModel()
    let generator = UIImpactFeedbackGenerator(style: .heavy)

    var body: some View {
        Button(action: {
            path.append("FrontScanView")
            generator.impactOccurred()
        }) {
            // Use a ZStack to ensure the entire area is tappable
            ZStack {
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 4 / 255, green: 96 / 255, blue: 255 / 255),
                        Color(red: 4 / 255, green: 180 / 255, blue: 255 / 255)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .cornerRadius(8)
                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)

                // Button text
                Text(title)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
            }
            .frame(maxWidth: 300, maxHeight: 80) // Set button dimensions
            .padding()
        }
    }
}


#Preview {
 
}
