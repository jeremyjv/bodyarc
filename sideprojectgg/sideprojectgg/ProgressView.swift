//
//  ProgressView.swift
//  sideprojectgg
//
//  Created by Jeremy Villanueva on 12/29/24.
//

import SwiftUI

struct ProgressView: View {
    @EnvironmentObject var viewModel: ContentViewModel
 
    
    @Binding var retrievedScanImages: [[UIImage?]]
    @Binding var scans: [ScanObject]?
    @Binding var path: NavigationPath
    

    
    var body: some View {
        VStack {
            Text("Your Progress")
                .font(.title)
                .padding()
            
            ScrollView {
                LazyVStack(spacing: 20) {
                    ForEach(retrievedScanImages.indices, id: \.self) { index in
                        HStack(spacing: 20) {
                            // Front Image Button
                            if let frontImage = retrievedScanImages[index][0] {
                                Button(action: {
                                    print("Front image button tapped for index \(index)")
                                    // Add your action here
                                }) {
                                    Image(uiImage: frontImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 150, height: 200)
                                        .cornerRadius(10)
                                        .overlay(
                                            Text("Front")
                                                .font(.caption)
                                                .padding(6)
                                                .background(Color.black.opacity(0.6))
                                                .foregroundColor(.white)
                                                .cornerRadius(5),
                                            alignment: .bottomTrailing
                                        )
                                }
                            } else {
                                // Button with a loading view
                                    Button(action: {
                                        print("Loading front image...")
                                    }) {
                                        VStack {
                                            
                                            Text("Loading...")
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                        }
                                        .frame(width: 150, height: 200)
                                        .background(Color.gray.opacity(0.3))
                                        .cornerRadius(10)
                                    }
                            }
                            
                            // Back Image Button
                            if let backImage = retrievedScanImages[index][0] {
                                Button(action: {
                                    print("Back image button tapped for index \(index)")
                                    // Add your action here
                                }) {
                                    Image(uiImage: backImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 150, height: 200)
                                        .cornerRadius(10)
                                        .overlay(
                                            Text("Back")
                                                .font(.caption)
                                                .padding(6)
                                                .background(Color.black.opacity(0.6))
                                                .foregroundColor(.white)
                                                .cornerRadius(5),
                                            alignment: .bottomTrailing
                                        )
                                }
                            } else {
                                Text("No Back Image")
                                    .frame(width: 150, height: 200)
                                    .background(Color.gray.opacity(0.3))
                                    .cornerRadius(10)
                            }
                        }
                    }
                }
                .padding()
            }
        }
        
    }
}
