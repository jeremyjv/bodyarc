//
//  NutritionRoutineView.swift
//  Body Arc
//
//  Created by Jeremy Villanueva on 2/3/25.
//

import SwiftUI

struct NutritionRoutineView: View {
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 20) {
                    // Main Title
                    Text("Nutrition")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()

                    // Overview Section
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Overview")
                            .font(.title)
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .center)

                        Text("The amount of calories and composition of macronutrients you have in your diet is dependent on your physique goals. What’s important about any diet is that you stick to it and find a way to make it fun and sustainable for the long term.")
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

                    // Cutting Section
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Cutting")
                            .font(.title)
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .center)

                        Text("Cutting is a phase where you reduce calorie intake to lose body fat while maintaining muscle mass. This typically involves a calorie deficit and increased focus on protein intake.")
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

                    // Bulking Section
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Bulking")
                            .font(.title)
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .center)

                        Text("Bulking is a phase where you increase calorie intake to gain muscle mass. This typically involves a calorie surplus and a focus on consuming enough protein and carbohydrates.")
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

                    // Recomposition Section
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Recomposition")
                            .font(.title)
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .center)

                        Text("Recomposition is a phase where you aim to lose fat and gain muscle simultaneously. This requires a careful balance of calorie intake, macronutrient distribution, and resistance training.")
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

                    // Maintaining Section
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Maintaining")
                            .font(.title)
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .center)

                        Text("Maintaining is a phase where you aim to keep your current body composition. This involves consuming enough calories to maintain your weight and focusing on a balanced diet.")
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
                .frame(maxWidth: .infinity)
                .padding()
            }
        }
        .background(Color(red: 15/255, green: 15/255, blue: 15/255).edgesIgnoringSafeArea(.all))
    }
}

#Preview {
    NutritionRoutineView()
}
