//
//  ShoulderRoutineView.swift
//  sideprojectgg
//
//  Created by Jeremy Villanueva on 1/10/25.
//

import SwiftUI


import SwiftUI

struct ShoulderRoutineView: View {
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 20) {
                    // Title
                    Text("Shoulders")
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

                        Text("Train shoulders with higher volume and intensity to grow the width of the upper body. (Adjust weight and volume accordingly). The key is to progressively overload by adding weight and/or reps each push workout.")
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

                    // Compound Movements Section
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Compound Movements")
                            .font(.title)
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .center)

                        // Overview Subsection
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Overview")
                                .font(.title2)
                                .fontWeight(.bold) // Bold subsection title
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .leading)

                            Text("Growth of the shoulders will primarily come from any compound pressing and pulling movement of the upper body. With compound movements we can overload with heavier weight -- creating the needed stimulus for growth.")
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

                        // Compound Training Styles Subsection
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Compound Training Styles")
                                .font(.title2)
                                .fontWeight(.bold) // Bold subsection title
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .leading)

                            Text("5×5 reps (Heavier Weight)\nStrength Focus")
                                .font(.body)
                                .foregroundColor(Color(red: 0.8, green: 0.8, blue: 0.8))
                                .frame(maxWidth: .infinity, alignment: .leading)

                            Text("3×(8-12) reps (Moderate Weight)\nHypertrophy Focus")
                                .font(.body)
                                .foregroundColor(Color(red: 0.8, green: 0.8, blue: 0.8))
                                .frame(maxWidth: .infinity, alignment: .leading)

                            Text("*Try different styles when you hit plateaus")
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

                        // Key Shoulder Compounds Subsection
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Key Compound Movements")
                                .font(.title2)
                                .fontWeight(.bold) // Bold subsection title
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .leading)

                            Text("1. Over Head Presses")
                                .font(.body)
                                .foregroundColor(Color(red: 0.8, green: 0.8, blue: 0.8))
                                .frame(maxWidth: .infinity, alignment: .leading)

                            Text("2. Incline Presses")
                                .font(.body)
                                .foregroundColor(Color(red: 0.8, green: 0.8, blue: 0.8))
                                .frame(maxWidth: .infinity, alignment: .leading)

                            Text("3. Bench Presses")
                                .font(.body)
                                .foregroundColor(Color(red: 0.8, green: 0.8, blue: 0.8))
                                .frame(maxWidth: .infinity, alignment: .leading)

                            Text("*Always control the weight to maximize growth and focus on squeezing the muscle. Never use momentum")
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

                    // Accessory Movements Section
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Accessory Movements")
                            .font(.title)
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .center)

                        // Overview Subsection
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Overview")
                                .font(.title2)
                                .fontWeight(.bold) // Bold subsection title
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .leading)

                            Text("Utilize Accessory movements to isolate and drive blood flow into the shoulder muscle. Train Hard.")
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

                        // Accessory Training Styles Subsection
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Accessory Training Styles")
                                .font(.title2)
                                .fontWeight(.bold) // Bold subsection title
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .leading)

                            Text("Straight Sets (Normal Sets)\nX Reps → Rest 3 Min")
                                .font(.body)
                                .foregroundColor(Color(red: 0.8, green: 0.8, blue: 0.8))
                                .frame(maxWidth: .infinity, alignment: .leading)

                            Text("Rest Pause Sets\nX Reps → 10s Rest → 0.5X Reps")
                                .font(.body)
                                .foregroundColor(Color(red: 0.8, green: 0.8, blue: 0.8))
                                .frame(maxWidth: .infinity, alignment: .leading)

                            Text("Drop Sets\nX Reps at Y Weight → Rest")
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

                        // Key Accessory Movements Subsection
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Key Accessory Movements")
                                .font(.title2)
                                .fontWeight(.bold) // Bold subsection title
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .leading)

                            Text("1. Dumbbell/Cable Lateral Raises")
                                .font(.body)
                                .foregroundColor(Color(red: 0.8, green: 0.8, blue: 0.8))
                                .frame(maxWidth: .infinity, alignment: .leading)

                            Text("2. Rear Delt Flies")
                                .font(.body)
                                .foregroundColor(Color(red: 0.8, green: 0.8, blue: 0.8))
                                .frame(maxWidth: .infinity, alignment: .leading)

                            Text("*Always control the weight to maximize growth and focus on squeezing the muscle. Never use momentum")
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

}
