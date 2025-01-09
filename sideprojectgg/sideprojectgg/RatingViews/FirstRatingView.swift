//
//  FirstRatingView.swift
//  sideprojectgg
//
//  Created by Jeremy Villanueva on 1/8/25.
//

import SwiftUI

struct FirstRatingView: View {
    @EnvironmentObject var viewModel: ContentViewModel
    var frontImage: UIImage?
    var backImage: UIImage?
    var scanObject: ScanObject
    
    
    
    var body: some View {
        VStack(spacing: 20) {
                // Title
                Text("Ratings")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 20)

                // Image
                if let image = frontImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(20)
                        .frame(width: 300, height: 400) // Adjust dimensions as needed
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.gray, lineWidth: 2)
                        )
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .cornerRadius(20)
                        .frame(width: 300, height: 400)
                        .overlay(Text("Loading Image...").foregroundColor(.gray))
                }

                // Ratings
                HStack(spacing: 20) {
                    VStack {
                        Text("V-Taper")
                            .font(.headline)
                            .foregroundColor(.white)
                        Text("82")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    VStack {
                        Text("Leanness")
                            .font(.headline)
                            .foregroundColor(.white)
                        Text("85")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    VStack {
                        Text("Overall")
                            .font(.headline)
                            .foregroundColor(.white)
                        Text("70")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    VStack {
                        Text("Potential")
                            .font(.headline)
                            .foregroundColor(.white)
                        Text("90")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.6))
                .cornerRadius(15)

                // Buttons
                HStack(spacing: 40) {
                    Button(action: {
                        print("Save tapped")
                    }) {
                        HStack {
                            Image(systemName: "square.and.arrow.down")
                            Text("Save")
                        }
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.gray)
                        .cornerRadius(10)
                    }

                    Button(action: {
                        print("Share tapped")
                    }) {
                        HStack {
                            Image(systemName: "paperplane")
                            Text("Share")
                        }
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.gray)
                        .cornerRadius(10)
                    }
                }

                Spacer()
            }
            .padding()
           
           
            
    }
}

