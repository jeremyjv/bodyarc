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
            
            Text("Ratings")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.top, -50)
           
            ZStack {
                
                
                
                // Ratings Section with Background
                ZStack {
                    // Black background for ratings
                    Rectangle()
                        .fill(Color(red: 0.05, green: 0.05, blue: 0.05))
                        .cornerRadius(20)
                        .frame(width: 320, height: 300) // Adjust height as needed
                    
                    
                    // Ratings
                    VStack(spacing: 20) {
                        HStack(spacing: 35) {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("V-Taper")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Text("82")
                                    .font(.system(size: 48, weight: .bold)) // Adjust size and weight here
                                    .foregroundColor(.white)
                                ProgressBar(score: 82)
                            }
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Leanness")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Text("85")
                                    .font(.system(size: 48, weight: .bold)) // Adjust size and weight here
                                    .foregroundColor(.white)
                                ProgressBar(score: 85)
                            }
                        }
                        HStack(spacing: 35) {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Overall")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Text("70")
                                    .font(.system(size: 48, weight: .bold)) // Adjust size and weight here
                                    .foregroundColor(.white)
                                ProgressBar(score: 70)
                            }
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Potential")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Text("20")
                                    .font(.system(size: 48, weight: .bold)) // Adjust size and weight here
                                    .foregroundColor(.white)
                                ProgressBar(score: 20)
                            }
                        }
                    }
                    .padding()
                    .offset(y: 20)
                }
                .offset(y: 250)
                
                // Image
                if let image = frontImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(20)
                        .frame(width: 300, height: 300) // Adjust dimensions as needed
                        .offset(y: 0)
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .cornerRadius(20)
                        .frame(width: 320, height: 270)
                        .overlay(Text("Loading Image...").foregroundColor(.gray))
                }
                
            }

            // Buttons
            HStack(spacing: 40) {
                Button(action: {
                    print("Save tapped")
                }) {
                    HStack {
                        Image(systemName: "square.and.arrow.down")
                        Text("Save")
                    }
                    .foregroundColor(.black)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                }

                Button(action: {
                    print("Share tapped")
                }) {
                    HStack {
                        Image(systemName: "paperplane")
                        Text("Share")
                    }
                    .foregroundColor(.black)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                }
            }
            .offset(y: 275)

            Spacer()
        }
        .padding()
        .navigationBarBackButtonHidden(true)
        
           
    }
}

