//
//  SecondBackRatingView.swift
//  sideprojectgg
//
//  Created by Jeremy Villanueva on 1/9/25.
//

import SwiftUI

struct SecondBackRatingView: View {
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
                    Text("Back Ratings")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    if let image = backImage {
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
                            .frame(minWidth: 200, maxWidth: 300, minHeight: 200, maxHeight: 300) // Adjust dimensions as needed
                            .overlay(Text("Loading Image...").foregroundColor(.gray))
                    }
                    
                    // Ratings
                    VStack(spacing: 20) {
                        HStack(spacing: 35) {
                            VStack {
                                Text("🌲")
                                    .font(.system(size: 30))
                                    .foregroundColor(.white)
                                Text("Lat Insertion")
                                    .font(.system(size: 15))
                                    .foregroundColor(.white.opacity(0.5)) // Faint white text
                                Text("\(scanObject.backAnalysis!.latInsertion)")
                                    .font(.system(size: 30, weight: .bold)) // Adjust size and weight here
                                    .foregroundColor(.white)
                            }
                            
                        }
                        HStack(spacing: 45) {
                            VStack {
                                Text("🐢")
                                    .font(.system(size: 30))
                                    .foregroundColor(.white)
                                Text("Back Density")
                                    .font(.system(size: 15))
                                    .foregroundColor(.white.opacity(0.5)) // Faint white text
                                Text("\(scanObject.backAnalysis!.density)")
                                    .font(.system(size: 30, weight: .bold)) // Adjust size and weight here
                                    .foregroundColor(.white)
                            }
                            VStack {
                                Image(uiImage: UIImage(named: "barn")!)
                                    .resizable() // Make the image resizable
                                    .scaledToFit() // Maintain the aspect ratio
                                    .frame(width: 30, height: 30) // Match the emoji size
                                    .offset(y: 2)
                                Text("Back Width")
                                    .font(.system(size: 15))
                                    .foregroundColor(.white.opacity(0.5)) // Faint white text
                                Text("\(scanObject.backAnalysis!.width)")
                                    .font(.system(size: 30, weight: .bold)) // Adjust size and weight here
                                    .foregroundColor(.white)
                            }
                            .offset(y: 1)
                        }
                        Text("bodyarc")
                            .font(.footnote) // Small font size
                            .foregroundColor(.white.opacity(0.3)) // Faint white text
                            .fontWeight(.bold)
                    }
                 
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




