//
//  ThirdRatingView.swift
//  sideprojectgg
//
//  Created by Jeremy Villanueva on 1/9/25.
//

import SwiftUI

struct ThirdRatingView: View {
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
                    VStack(spacing: 10) {
                        HStack(spacing: 35) {
                            VStack {
                                Text("👤")
                                    .font(.system(size: 45))
                                    .foregroundColor(.white)
                                Text("Body Type")
                                    .font(.system(size: 15))
                                    .foregroundColor(.white.opacity(0.5)) // Faint white text
                                Text("\(scanObject.frontAnalysis!.bodyType!)")
                                    .font(.system(size: 30, weight: .bold)) // Adjust size and weight here
                                    .foregroundColor(.white)
                            }
                
                        }
                        HStack(spacing: 35) {
                            VStack {
                                Text("📐")
                                    .font(.system(size: 45))
                                    .foregroundColor(.white)
                                Text("Clavicle Width")
                                    .font(.system(size: 15))
                                    .foregroundColor(.white.opacity(0.5)) // Faint white text
                                Text("\(scanObject.frontAnalysis!.clavicleWidth!)")
                                    .font(.system(size: 30, weight: .bold)) // Adjust size and weight here
                                    .foregroundColor(.white)
                            }
                            VStack {
                                Text("💎")
                                    .font(.system(size: 45))
                                    .foregroundColor(.white)
                                Text("Waist Size")
                                    .font(.system(size: 15))
                                    .foregroundColor(.white.opacity(0.5)) // Faint white text
                                Text("\(scanObject.frontAnalysis!.waistSize!)")
                                    .font(.system(size: 30, weight: .bold)) // Adjust size and weight here
                                    .foregroundColor(.white)
                            }
                        }
                        Text("bodyarc")
                                    .font(.footnote) // Small font size
                                    .foregroundColor(.white.opacity(0.3)) // Faint white text
                                    .fontWeight(.bold)
                    }
        
                    .offset(y: 16)
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


