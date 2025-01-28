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
            Color.black.edgesIgnoringSafeArea(.all)

            VStack(spacing: 40) {
                // Bad Photos Section
                VStack(alignment: .leading, spacing: 20) {
                    Text("Bad Photos")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.red)

                    HStack(spacing: 15) {
                        Image("bad1") // Replace with your image asset
                            .resizable()
                            .scaledToFill()
                            .frame(width: 80, height: 120)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        Image("bad2")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 80, height: 120)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        Image("bad3")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 80, height: 120)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }

                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.red)
                            Text("Pixelated or blurry face")
                        }
                        HStack {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.red)
                            Text("Too far away")
                        }
                        HStack {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.red)
                            Text("Photos with heavy editing")
                        }
                    }
                    .font(.subheadline)
                    .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity, maxHeight: 300)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.3), radius: 4, x: 0, y: 2)

                // Good Photos Section
                VStack(alignment: .leading, spacing: 20) {
                    Text("Good Photos")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.green)

                    HStack(spacing: 15) {
                        Image("good1") // Replace with your image asset
                            .resizable()
                            .scaledToFill()
                            .frame(width: 80, height: 120)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        Image("good2")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 80, height: 120)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        Image("good3")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 80, height: 120)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }

                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                            Text("Clear high resolution image")
                        }
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                            Text("Selfie taken at arm's length")
                        }
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                            Text("No editing – raw image")
                        }
                    }
                    .font(.subheadline)
                    .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity, maxHeight: 300)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.3), radius: 4, x: 0, y: 2)

                // Continue Button
                CustomScanButton(title: "Continue", path: $path, dest: "FrontScanView")
            }
            .padding()
        }
    }
}
#Preview {
    
}
