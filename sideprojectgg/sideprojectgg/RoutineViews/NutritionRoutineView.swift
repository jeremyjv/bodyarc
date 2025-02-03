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

                        Text("The amount of calories and composition of macronutrients you have in your diet is dependent on your physique goals. What’s important about any diet is that you stick to it and form habits around it in order to make it fun and sustainable in the long term.")
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

                        Text("Target a 300-500 calorie deficit and 1-1.2 grams of protein per pound of body weight.")
                            .font(.body)
                            .foregroundColor(Color(red: 0.8, green: 0.8, blue: 0.8))
                            .frame(maxWidth: .infinity, alignment: .leading)

                        Text("It’s easy to lose muscle mass during a cut, so it’s important to continue training hard during your cut.")
                            .font(.body)
                            .foregroundColor(Color(red: 0.8, green: 0.8, blue: 0.8))
                            .frame(maxWidth: .infinity, alignment: .leading)

                        Text("To help you achieve a deficit: generally eat whole foods to stay full and do more low impact activities such as walking.")
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

                        Text("Target a 300-500 calorie surplus and 1-1.2 grams of protein per pound of body weight.")
                            .font(.body)
                            .foregroundColor(Color(red: 0.8, green: 0.8, blue: 0.8))
                            .frame(maxWidth: .infinity, alignment: .leading)

                        Text("During a bulk you want to add more volume to workouts and train muscles harder to take full advantage of the caloric surplus.")
                            .font(.body)
                            .foregroundColor(Color(red: 0.8, green: 0.8, blue: 0.8))
                            .frame(maxWidth: .infinity, alignment: .leading)

                        Text("Never dirty bulk unless you only care about strength, since you’ll end up with excess fat that will take a long time to burn off.")
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

                        Text("Target a low caloric deficit 300-400 and 1-1.2 grams of protein per pound of body weight.")
                            .font(.body)
                            .foregroundColor(Color(red: 0.8, green: 0.8, blue: 0.8))
                            .frame(maxWidth: .infinity, alignment: .leading)

                        Text("Gaining muscle and losing fat will have the most effect on beginner lifters, and this is the best option for those starting off as “skinny fat”. Recomposition as an experienced lifter is still possible but it often takes longer to build more muscle this way and requires a very minimal caloric deficit to avoid losing muscle.")
                            .font(.body)
                            .foregroundColor(Color(red: 0.8, green: 0.8, blue: 0.8))
                            .frame(maxWidth: .infinity, alignment: .leading)

                        Text("Despite the deficit it is still important to train hard to ensure muscle growth.")
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

                        Text("Target a caloric maintenance and 1-1.2 grams of protein per pound of body weight.")
                            .font(.body)
                            .foregroundColor(Color(red: 0.8, green: 0.8, blue: 0.8))
                            .frame(maxWidth: .infinity, alignment: .leading)

                        Text("Assuming you already have the physique you admire, you can spend less time in the gym by focusing on compound movements that hit multiple muscle groups at once and isolation movements that target your weaker muscles.")
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

