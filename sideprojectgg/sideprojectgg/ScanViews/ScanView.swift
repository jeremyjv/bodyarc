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
                    .frame(width: 320, height: 500)
                    .cornerRadius(30)
                CustomScanButton(title: "Begin Scan", path: $path)
                
            }
            
        }
    
        
    }
  
}

struct CustomScanButton: View {
    var title: String
    @Binding var path: NavigationPath
    @StateObject private var cameraModel = CameraModel()


    var body: some View {
        
    
        HStack {
            Button(action: {
                path.append("FrontScanView")
            }) {
                Text(title) // Button title
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white) // Text color
            }
            .frame(maxWidth: 300, minHeight: 40) // Set button dimensions
            .padding() // Add padding inside the button
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color(red: 4/255, green: 96/255, blue: 255/255), Color(red: 4/255, green: 180/255, blue: 255/255)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(8) // Rounded corners
            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2) // Shadow
        }
        
    
    }

    
}


#Preview {
 
}
