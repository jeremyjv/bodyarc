//
//  FrontInstructionsView.swift
//  sideprojectgg
//
//  Created by Jeremy Villanueva on 1/26/25.
//

import SwiftUI

struct FrontInstructionsView: View {
    @Binding var path: NavigationPath
    let generator = UIImpactFeedbackGenerator(style: .heavy)

    var body: some View {
        ZStack {
            // Background Color
            Color(red: 15/255, green: 15/255, blue: 15/255)
                .edgesIgnoringSafeArea(.all) // Ensures it covers the entire screen

            VStack(spacing: 15) { // Reduced spacing between sections
                // Title
                Text("Scan Instructions")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 10) // Minimal padding for the title

                // Good Photos Section
                VStack(alignment: .leading, spacing: 10) {
                    Text("Good Photos")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.green)
                        .padding(.horizontal, 10) // Align closer to the left side

                    // Centered Images in HStack
                    HStack() {
                        Spacer()
                        Image("frontgood1") // Replace with your image asset
                            .resizable()
                            .scaledToFill()
                            .frame(width: 70, height: 110)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        Spacer()
                        Image("frontgood2")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 70, height: 110)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        Spacer()
                        Image("backgood1")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 70, height: 110)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, alignment: .center) // Center images in HStack

                    VStack(alignment: .leading, spacing: 5) { // Increased spacing for better readability
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                                .font(.system(size: 16)) // Smaller icon size
                            Text("Clear high resolution image")
                                .font(.system(size: 18)) // Text size remains the same
                        }
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                                .font(.system(size: 16)) // Smaller icon size
                            Text("Torso completely visible")
                                .font(.system(size: 18)) // Text size remains the same
                        }
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                                .font(.system(size: 16)) // Smaller icon size
                            Text("No editing – raw image")
                                .font(.system(size: 18)) // Text size remains the same
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

                // Bad Photos Section
                VStack(alignment: .leading, spacing: 10) {
                    Text("Bad Photos")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.red)
                        .padding(.horizontal, 10) // Align closer to the left side

                    // Centered Images in HStack
                    HStack() {
                        Spacer()
                        Image("frontbad1") // Replace with your image asset
                            .resizable()
                            .scaledToFill()
                            .frame(width: 70, height: 110)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        Spacer()
                        Image("frontbad2")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 70, height: 110)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        Spacer()
                        Image("backbad1")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 70, height: 110)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, alignment: .center) // Center images in HStack

                    VStack(alignment: .leading, spacing: 5) { // Increased spacing for better readability
                        HStack {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.red)
                                .font(.system(size: 16)) // Smaller icon size
                            Text("Pixelated or blurry")
                                .font(.system(size: 18)) // Text size remains the same
                        }
                        HStack {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.red)
                                .font(.system(size: 16)) // Smaller icon size
                            Text("Too far away")
                                .font(.system(size: 18)) // Text size remains the same
                        }
                        HStack {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.red)
                                .font(.system(size: 16)) // Smaller icon size
                            Text("Lighting too dark")
                                .font(.system(size: 18)) // Text size remains the same
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

                // Continue Button
                CustomScanButton(title: "Continue", path: $path, dest: "FrontScanView")
            }
            .padding(.horizontal) // Remove extra padding from the outer VStack
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        path.removeLast()
                        generator.impactOccurred()
                    }) {
                        HStack {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.gray) // Set the color to gray
                        }
                    }
                }
            }
        }
    }
}
#Preview {
    
}
