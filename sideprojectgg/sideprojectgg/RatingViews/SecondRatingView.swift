//
//  SecondRatingView.swift
//  sideprojectgg
//
//  Created by Jeremy Villanueva on 1/9/25.
//

import SwiftUI

struct SecondRatingView: View {
    @EnvironmentObject var viewModel: ContentViewModel
    var frontImage: UIImage?
    var backImage: UIImage?
    var scanObject: ScanObject
    
   
    
    
    
    var body: some View {

        VStack(spacing: 20) {
            
            Text("Front Ratings")
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
                                Text("Shoulders")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Text("\(scanObject.frontAnalysis!.shoulders)")
                                    .font(.system(size: 48, weight: .bold)) // Adjust size and weight here
                                    .foregroundColor(.white)
                                ProgressBar(score: scanObject.frontAnalysis!.shoulders)
                            }
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Chest")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Text("\(scanObject.frontAnalysis!.chest)")
                                    .font(.system(size: 48, weight: .bold)) // Adjust size and weight here
                                    .foregroundColor(.white)
                                ProgressBar(score: scanObject.frontAnalysis!.chest)
                            }
                        }
                        HStack(spacing: 35) {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Arms")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Text("\(scanObject.frontAnalysis!.arms)")
                                    .font(.system(size: 48, weight: .bold)) // Adjust size and weight here
                                    .foregroundColor(.white)
                                ProgressBar(score: scanObject.frontAnalysis!.arms)
                            }
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Abs")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Text("\(scanObject.frontAnalysis!.abs)")
                                    .font(.system(size: 48, weight: .bold)) // Adjust size and weight here
                                    .foregroundColor(.white)
                                ProgressBar(score: scanObject.frontAnalysis!.abs)
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
                if let image = frontImage {
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

