//
//  AbsRoutineView.swift
//  sideprojectgg
//
//  Created by Jeremy Villanueva on 1/12/25.
//

import SwiftUI

struct AbsRoutineView: View {
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 20) {
                    // Title
                    Text("Abs")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()

                    // Goal Section
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Goal")
                            .font(.title)
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .center)

                        Text("Visible abs are a direct result of your body fat percentage. The bracing required for compound exercises such as squats, deadlifts, and overhead presses sufficiently strengthens the abs.")
                            .font(.body)
                            .foregroundColor(Color(red: 0.8, green: 0.8, blue: 0.8))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text("Given a low body fat percentage, we want to accentuate the visible muscle separation in the abs to achieve the ‘Checkerboard Abs’ look.")
                            .font(.body)
                            .foregroundColor(Color(red: 0.8, green: 0.8, blue: 0.8))
                            .frame(maxWidth: .infinity, alignment: .leading)

                        Text("*If you have a higher body fat percentage, first focus on your caloric deficit to lose fat so your ab muscles become visible.")
                            .font(.body)
                            .foregroundColor(Color(red: 0.8, green: 0.8, blue: 0.8))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding()
                    .frame(maxWidth: geometry.size.width * 0.9)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 2)
                    )

                    // Accessory Movements Section
                    VStack {
                        Text("Accessory Movements")
                            .font(.title)
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .center)

                        // Overview Subsection
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Overview")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text("To maximize ab growth during exercises, slow down the reps and focus on the bending and contraction of your torso. With bodyweight ab exercises, you’ll target rep ranges of 12-30, and with weighted ab exercises you’ll target rep ranges of 8-16.")
                                .font(.body)
                                .foregroundColor(Color(red: 0.8, green: 0.8, blue: 0.8))
                                .frame(maxWidth: .infinity, alignment: .leading)

                            Text("But what’s more important than the amount of reps is the burn you feel in your abs during the exercise. You may feel it better in one exercise than another, so play around with what feels best.")
                                .font(.body)
                                .foregroundColor(Color(red: 0.8, green: 0.8, blue: 0.8))
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding()
                        .frame(maxWidth: geometry.size.width * 0.9)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 2)
                        )

                        // Accessory Training Styles
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Accessory Training Styles")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .leading)

                            Text("Straight Sets")
                                .font(.body)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            Text("X Reps → Rest 3 Min")
                                .foregroundColor(Color(red: 0.8, green: 0.8, blue: 0.8)) // Previously white, now gray
                        }
                        .padding()
                        .frame(maxWidth: geometry.size.width * 0.9)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 2)
                        )

                        // Key Accessory Movements
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Key Accessory Movements")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .leading)

                            Text("1. Hanging Leg Raises")
                                .font(.body)
                                .foregroundColor(Color(red: 0.8, green: 0.8, blue: 0.8))
                                .frame(maxWidth: .infinity, alignment: .leading)

                            Text("2. Body Weight Crunches")
                                .font(.body)
                                .foregroundColor(Color(red: 0.8, green: 0.8, blue: 0.8))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text("3. Cable Crunches")
                                .font(.body)
                                .foregroundColor(Color(red: 0.8, green: 0.8, blue: 0.8))
                                .frame(maxWidth: .infinity, alignment: .leading)

                            Text("4. Medicine Ball Twists")
                                .font(.body)
                                .foregroundColor(Color(red: 0.8, green: 0.8, blue: 0.8))
                                .frame(maxWidth: .infinity, alignment: .leading)

                            Text("*Focus on stretch and contraction")
                                .font(.body)
                                .foregroundColor(Color(red: 0.8, green: 0.8, blue: 0.8))
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding()
                        .frame(maxWidth: geometry.size.width * 0.9)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 2)
                        )
                    }
                    .padding()
                    .frame(maxWidth: geometry.size.width * 0.9)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 2)
                    )
                }
                .frame(maxWidth: .infinity)
                .padding()
            }
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}

#Preview {
    AbsRoutineView()
}
