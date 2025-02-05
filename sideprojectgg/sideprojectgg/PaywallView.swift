//
//  PaywallView.swift
//  sideprojectgg
//
//  Created by Jeremy Villanueva on 1/18/25.
//

import SwiftUI
import RevenueCat
import FirebaseFirestore


struct PaywallView: View {
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack {
                LinearGradient(
                        gradient: Gradient(colors: [
                            Color.yellow.opacity(0.2), // Start with a yellowish hue
                            Color.clear,               // Fade to transparent
                            Color.black
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: UIScreen.main.bounds.height * 0.5) // Top 30% of the screen
                Spacer()
            }
            .edgesIgnoringSafeArea(.top)
            
            VStack(spacing: 20) {
                // Header Section
            
                
                
                Spacer()
                
                // Logo Section
                Image(uiImage: UIImage(named: "clearBodyArc")!) // Replace with your logo asset
                    .resizable()
                    .frame(width: 100, height: 100)
                    .scaledToFit()
                
                // Title Section
                Text("Get Body Arc Gold 🏆")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Spacer()
                Spacer()
                
                // Features Section
                VStack(alignment: .leading, spacing: 50) {
                    FeatureRow(title: "See Your Ratings 👤", description: "View your results and share your ratings with friends")
                    FeatureRow(title: "Start Your Aesthetics Plan 💪", description: "Full Access to Body Building Style Reps, Sets, and Progressions for Growth")
                    FeatureRow(title: "Scan Weekly 📸", description: "One scan per week to document your physique progress")
                }
                .padding(.horizontal, 20)
                
                Spacer()
            }
        }
    }
}

struct FeatureRow: View {
    let title: String
    let description: String

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            // Icon Section
            Image(uiImage: UIImage(named: "lock")!)
                .padding(16)
                .frame(width: 20, height: 20)

            VStack(alignment: .leading, spacing: 5) {
                // Title
                Text(title)
                    .font(.title3)
                    .fontWeight(.bold) // Applies bold weight
                    .foregroundColor(.white)
                    .fixedSize(horizontal: false, vertical: true)

                // Description
                Text(description)
                    .font(.body)
                    .foregroundColor(.gray)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.leading, 10)
        }
        
    }

}

#Preview {

}
