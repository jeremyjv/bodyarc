//
//  ChestRoutineView.swift
//  sideprojectgg
//
//  Created by Jeremy Villanueva on 1/12/25.
//

import SwiftUI

struct ChestRoutineView: View {
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 20) {
                    // Title
                    Text("Chest")
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

                        Text("Train chest with a focus on the upper chest to achieve a ‘fuller’ look of the upper body. Growth of the chest is very dependent on how you perform the reps.")
                            .font(.body)
                            .foregroundColor(Color(red: 0.8, green: 0.8, blue: 0.8))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text("We want to prioritize exercises that have a deep stretch and allow us to focus on the contraction of the chest and not let the shoulder muscles take over. This in combination with progressive overload with weights and/or reps is the main driver for chest growth.")
                            .font(.body)
                            .foregroundColor(Color(red: 0.8, green: 0.8, blue: 0.8))
                            .frame(maxWidth: .infinity, alignment: .leading)

                        Text("*Instead of thinking of pushing the weight, think about bringing your elbows together to focus on the chest contraction during the push exercise.")
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
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .leading)

                            Text("Most of your chest growth will come primarily from compound pressing movements. With compound movements we can overload with heavier weight – creating the needed stimulus for growth.")
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

                        // Compound Training Styles
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Compound Training Styles")
                                .font(.title2)
                                .fontWeight(.bold)
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

                        // Key Compound Movements
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Key Compound Movements")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .leading)

                            Text("1. Incline Press (Dumbbell/Barbell)")
                                .font(.body)
                                .foregroundColor(Color(red: 0.8, green: 0.8, blue: 0.8))
                                .frame(maxWidth: .infinity, alignment: .leading)

                            Text("2. Bench Press (Dumbbell/Barbell)")
                                .font(.body)
                                .foregroundColor(Color(red: 0.8, green: 0.8, blue: 0.8))
                                .frame(maxWidth: .infinity, alignment: .leading)

                            Text("3. Dips (Weighted/Bodyweight)")
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
                    
                    VStack {
                        // Accessory Movements Section
                        Text("Accessory Movements")
                            .font(.title)
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .center)
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Overview")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text("We use accessory movements to take away the emphasis on the shoulders and triceps that compound movements have which allows us to strictly focus on the contraction of the chest.")
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

                        VStack(alignment: .leading, spacing: 10) {
                            Text("Key Accessory Movements")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .leading)

                            Text("1. Chest Flies (Cable or Machine)")
                            Text("2. Incline Dumbbell Press")
                            Text("*focus on stretch and contraction")
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
    ChestRoutineView()
}
