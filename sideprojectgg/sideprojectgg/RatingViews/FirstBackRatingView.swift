//
//  FirstBackRatingView.swift
//  sideprojectgg
//
//  Created by Jeremy Villanueva on 1/9/25.
//

import SwiftUI

struct FirstBackRatingView: View {
    @EnvironmentObject var viewModel: ContentViewModel
    var frontImage: UIImage?
    var backImage: UIImage?
    var scanObject: ScanObject
    
   
    
    
    
    var body: some View {

        VStack(spacing: 20) {
            
            Text("Back Ratings")
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
                                Text("Traps")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Text("\(scanObject.backAnalysis!.traps)")
                                    .font(.system(size: 48, weight: .bold)) // Adjust size and weight here
                                    .foregroundColor(.white)
                                ProgressBar(score: scanObject.backAnalysis!.traps)
                            }
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Lats")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Text("\(scanObject.backAnalysis!.lats)")
                                    .font(.system(size: 48, weight: .bold)) // Adjust size and weight here
                                    .foregroundColor(.white)
                                ProgressBar(score: scanObject.backAnalysis!.lats)
                            }
                        }
                        HStack(spacing: 35) {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Rear Delts")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Text("\(scanObject.backAnalysis!.rearDelts)")
                                    .font(.system(size: 48, weight: .bold)) // Adjust size and weight here
                                    .foregroundColor(.white)
                                ProgressBar(score: scanObject.backAnalysis!.rearDelts)
                            }
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Lower Back")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Text("\(scanObject.backAnalysis!.lowerBack)")
                                    .font(.system(size: 48, weight: .bold)) // Adjust size and weight here
                                    .foregroundColor(.white)
                                ProgressBar(score: scanObject.backAnalysis!.lowerBack)
                            }
                        }
                        Text("bodyarc")
                                    .font(.footnote) // Small font size
                                    .foregroundColor(.white.opacity(0.3)) // Faint white text
                                    .fontWeight(.bold)
                    }
                    .padding()
                    .offset(y: 20)
                }
                .offset(y: 250)
                
                // Image
                if let image = backImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(20)
                        .frame(width: 300, height: 300) // Adjust dimensions as needed
                        .offset(y: -20)
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .cornerRadius(20)
                        .frame(width: 320, height: 270)
                        .overlay(Text("Loading Image...").foregroundColor(.gray))
                }
                
            }

            // Buttons
            HStack(spacing: 25) {
                Button(action: {
                    print("Save tapped")
                }) {
                    HStack {
                        Text("Save")
                            .font(.system(size: 20, weight: .bold)) // Larger font size
                        Image(systemName: "square.and.arrow.down")
                            .font(.system(size: 24)) // Larger icon size
                    }
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white)
                    .cornerRadius(15) // Corner radius for better aesthetics
                }
                .frame(width: 160, height: 60) // Explicit frame size for the button
                
                Button(action: {
                    print("Share tapped")
                }) {
                    HStack {
                        Text("Share")
                            .font(.system(size: 20, weight: .bold)) // Larger font size
                        Image(systemName: "paperplane")
                            .font(.system(size: 24)) // Larger icon size
                    }
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white)
                    .cornerRadius(15) // Corner radius for better aesthetics
                }
                .frame(width: 160, height: 60) // Explicit frame size for the button
            }
            .offset(y: 265)

            Spacer()
        }
        .padding()
        .navigationBarBackButtonHidden(true)
        
           
    }
}

