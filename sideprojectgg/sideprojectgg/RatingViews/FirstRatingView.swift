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
    var saveAction: (String) -> Void
    let generator = UIImpactFeedbackGenerator(style: .heavy)
    var body: some View {

        VStack() {
            
            // Ratings Section with Background
            ZStack {
                // Black background for ratings
                
                VStack {
                    
                    Spacer()
                    Rectangle()
                        .fill(Color(red: 0.05, green: 0.05, blue: 0.05))
                        .cornerRadius(20)
                        .frame(minWidth: 320, maxWidth: 320, minHeight: 250, maxHeight: 300) // Adjust height as needed
                    
                }
       
                
                
                // Ratings
                VStack(spacing: 20) {
                    Text("Front Ratings")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        
                    if let image = frontImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(20)
                            //.frame(width: 300, height: 300) // Adjust dimensions as needed
                            .frame(minWidth: 200, maxWidth: 300, minHeight: 200, maxHeight: 300) // Adjust dimensions as needed
                          
                    } else {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .cornerRadius(20)
                            .frame(width: 320, height: 270)
                            .overlay(Text("Loading Image...").foregroundColor(.gray))
                    }
                    HStack(spacing: 35) {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("V-Taper")
                                .font(.headline)
                                .foregroundColor(.white)
                            Text("\(scanObject.frontAnalysis!.vTaper)")
                                .font(.system(size: 48, weight: .bold)) // Adjust size and weight here
                                .foregroundColor(.white)
                            ProgressBar(score: scanObject.frontAnalysis!.vTaper)
                        }
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Leanness")
                                .font(.headline)
                                .foregroundColor(.white)
                            Text("\(scanObject.frontAnalysis!.bodyFatPercentage)")
                                .font(.system(size: 48, weight: .bold)) // Adjust size and weight here
                                .foregroundColor(.white)
                            ProgressBar(score: scanObject.frontAnalysis!.bodyFatPercentage)
                        }
                    }
                    HStack(spacing: 35) {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Overall")
                                .font(.headline)
                                .foregroundColor(.white)
                            Text("\(scanObject.frontAnalysis!.overall)")
                                .font(.system(size: 48, weight: .bold)) // Adjust size and weight here
                                .foregroundColor(.white)
                            ProgressBar(score: scanObject.frontAnalysis!.overall)
                        }
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Potential")
                                .font(.headline)
                                .foregroundColor(.white)
                            Text("\(scanObject.frontAnalysis!.potential)")
                                .font(.system(size: 48, weight: .bold)) // Adjust size and weight here
                                .foregroundColor(.white)
                            ProgressBar(score: scanObject.frontAnalysis!.potential)
                        }
                    }
                    Text("bodyarc")
                                .font(.footnote) // Small font size
                                .foregroundColor(.white.opacity(0.3)) // Faint white text
                                .fontWeight(.bold)
               
                }
                .padding()
        
     
            }
                
    

            // Buttons
            HStack(spacing: 25) {
                Button(action: {
                    generator.impactOccurred()
                    saveAction("save")
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
                    generator.impactOccurred()
                    saveAction("share")
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
  


   


        }
        .navigationBarBackButtonHidden(true)
        .offset(y: -35)
        
           
    }
}

