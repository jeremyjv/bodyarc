//
//  FrontInstructionsView.swift
//  sideprojectgg
//
//  Created by Jeremy Villanueva on 1/26/25.
//

import SwiftUI

struct FrontInstructionsView: View {
    @Binding var path: NavigationPath

    var body: some View {
        ZStack {
            // Background Color
            Color(red: 15/255, green: 15/255, blue: 15/255)
                .edgesIgnoringSafeArea(.all) // Ensures it covers the entire screen

            VStack(spacing: 15) { // Increased spacing between sections
                // Title
                Text("Front Instructions")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 10) // Minimal padding for the title

                // Bad Photos Section
                VStack(alignment: .leading, spacing: 20) {
                    Text("Bad Photos")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.red)
                        .padding(.horizontal, 10) // Align closer to the left side

                    HStack(spacing: 15) {
                        Image("bad1") // Replace with your image asset
                            .resizable()
                            .scaledToFill()
                            .frame(width: 60, height: 90)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        Image("bad2")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 60, height: 90)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        Image("bad3")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 60, height: 90)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    .padding(.leading, 10) // Align images closer to the left

                    VStack(alignment: .leading, spacing: 5) { // Increased spacing for better readability
                        HStack {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.red)
                                .font(.system(size: 22)) // Increased icon size
                            Text("Pixelated or blurry face")
                                .font(.system(size: 18)) // Increased text size
                        }
                        HStack {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.red)
                                .font(.system(size: 22)) // Increased icon size
                            Text("Too far away")
                                .font(.system(size: 18)) // Increased text size
                        }
                        HStack {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.red)
                                .font(.system(size: 22)) // Increased icon size
                            Text("Photos with heavy editing")
                                .font(.system(size: 18)) // Increased text size
                        }
                    }
                    .foregroundColor(.white)
                    .padding(.leading, 10) // Align instructions closer to the left edge
                }
                .padding(.vertical, 15) // Add vertical padding for the entire Bad Photos section
                .frame(maxWidth: .infinity, maxHeight: 250, alignment: .leading) // Ensure full width alignment
                .background(Color.gray.opacity(0.2))
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.3), radius: 4, x: 0, y: 2)

                // Good Photos Section
                VStack(alignment: .leading, spacing: 20) {
                    Text("Good Photos")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.green)
                        .padding(.horizontal, 10) // Align closer to the left side

                    HStack(spacing: 15) {
                        Image("good1") // Replace with your image asset
                            .resizable()
                            .scaledToFill()
                            .frame(width: 60, height: 90)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        Image("good2")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 60, height: 90)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        Image("good3")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 60, height: 90)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    .padding(.leading, 10) // Align images closer to the left

                    VStack(alignment: .leading, spacing: 5) { // Increased spacing for better readability
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                                .font(.system(size: 22)) // Increased icon size
                            Text("Clear high resolution image")
                                .font(.system(size: 18)) // Increased text size
                        }
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                                .font(.system(size: 22)) // Increased icon size
                            Text("Selfie taken at arm's length")
                                .font(.system(size: 18)) // Increased text size
                        }
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                                .font(.system(size: 22)) // Increased icon size
                            Text("No editing – raw image")
                                .font(.system(size: 18)) // Increased text size
                        }
                    }
                    .foregroundColor(.white)
                    .padding(.leading, 10) // Align instructions closer to the left edge
                }
                .padding(.vertical, 15) // Add vertical padding for the entire Good Photos section
                .frame(maxWidth: .infinity, maxHeight: 250, alignment: .leading) // Ensure full width alignment
                .background(Color.gray.opacity(0.2))
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.3), radius: 4, x: 0, y: 2)

                // Continue Button
                CustomScanButton(title: "Continue", path: $path, dest: "FrontScanView")
            }
            .padding(.horizontal) // Remove extra padding from the outer VStack
        }
    }
}
#Preview {
    
}
