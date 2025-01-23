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
        VStack(spacing: 20) {
            // Header Section
            HStack {
                Button(action: {
                    // Dismiss or close action
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.gray)
                        .padding()
                }
                Spacer()
            }
            .padding(.top)
        

            Spacer()

            // Logo Section
            Image(uiImage: UIImage(named: "BodyArc3")!) // Replace with your logo asset
                .resizable()
                .frame(width: 80, height: 80)
                .scaledToFit()

            // Title Section
            Text("Get Body Arc Gold 🏆")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)

            Spacer()

            // Features Section
            VStack(alignment: .leading, spacing: 30) {
                FeatureRow(icon: "lock", title: "See Your Ratings 👤", description: "View your results and share your ratings with friends")
                FeatureRow(icon: "lock", title: "Start Your Aesthetics Plan 💪", description: "Full Access to Body Building Style Reps, Sets, and Progressions for Growth")
                FeatureRow(icon: "lock", title: "Scan Weekly 📸", description: "One scan per week to document your physique progress")
            }
            .padding(.horizontal, 20)

            Spacer()
        }
        .background(Color.black.edgesIgnoringSafeArea(.all)) // Background color
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String

    var body: some View {
        HStack(alignment: .top) {
            // Icon Section
            Image(systemName: icon)
                .foregroundColor(.white)
                .padding(8)
                .background(Circle().fill(Color.gray))
                .frame(width: 40, height: 40)

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
