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

                        Text("Train shoulders with higher volume and intensity to grow the width of the upper body. The key is to progressively overload by adding weight and/or reps each push workout.")
                            .font(.body)
                            .foregroundColor(Color(red: 0.8, green: 0.8, blue: 0.8))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text("To increase volume, specialize shoulders and add 2-4 more sets of shoulder exercises per week. To increase training intensity, use the style of sets and reps noted below ")
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

                            Text("Growth of the shoulders will primarily come from any compound pressing and pulling movement of the upper body. With compound movements we can overload with heavier weight – creating the needed stimulus for growth.")
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
                            
                            Text("Strength Focus\n") // Previously gray, now white
                                .font(.body)
                                .fontWeight(.bold)
                                .foregroundColor(.white) +
                            Text("5×5 reps (Heavier Weight)")
                                .foregroundColor(Color(red: 0.8, green: 0.8, blue: 0.8)) // Previously white, now gray
                            
                            Text("Hypertrophy Focus\n") // Previously gray, now white
                                .font(.body)
                                .fontWeight(.bold)
                                .foregroundColor(.white) +
                            Text("3×(8-16) reps (Moderate Weight)")
                                .foregroundColor(Color(red: 0.8, green: 0.8, blue: 0.8)) // Previously white, now gray

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

                            Text("Utilize accessory movements to isolate and drive blood flow into the shoulder muscles. Train Hard.")
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
                                .fontWeight(.bold)
                                .foregroundColor(.white) // Inverted: was white, now gray
                                .frame(maxWidth: .infinity, alignment: .leading)

                            Text("Straight Sets (Normal Sets)\n") // Previously gray, now white
                                .font(.body)
                                .fontWeight(.bold)
                                .foregroundColor(.white) +
                            Text("X Reps → Rest 3 Min")
                                .foregroundColor(Color(red: 0.8, green: 0.8, blue: 0.8)) // Previously white, now gray

                            Text("Rest Pause Sets\n") // Previously gray, now white
                                .font(.body)
                                .fontWeight(.bold)
                                .foregroundColor(.white) +
                            Text("X Reps → 10s Rest → 0.5X Reps")
                                .foregroundColor(Color(red: 0.8, green: 0.8, blue: 0.8)) // Previously white, now gray

                            Text("Drop Sets\n") // Previously gray, now white
                                .font(.body)
                                .fontWeight(.bold)
                                .foregroundColor(.white) +
                            Text("X Reps at Y Weight → Rest\nX Reps at 0.75Y Weight → Rest\nX Reps at 0.5Y Weight → Rest")
                                .foregroundColor(Color(red: 0.8, green: 0.8, blue: 0.8)) // Previously white, now gray

                            Text("Partial Reps\n") // Previously gray, now white
                                .font(.body)
                                .fontWeight(.bold)
                                .foregroundColor(.white) +
                            Text("Full ROM to failure →\nHalf ROM to failure")
                                .foregroundColor(Color(red: 0.8, green: 0.8, blue: 0.8)) // Previously white, now gray

                            Text("*ROM = Range of Motion")
                                .font(.body)
                                .foregroundColor(Color(red: 0.8, green: 0.8, blue: 0.8)) // Previously gray, now white
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
