//
//  LatsRoutineView.swift
//  sideprojectgg
//
//  Created by Jeremy Villanueva on 1/12/25.
//

import Foundation
import SwiftUI

struct LatsRoutineView: View {
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 20) {
                    // Title
                    Text("Lats")
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

                        Text("The lats are responsible for giving your back a wider and V-Taper look. Growth of the lats is very dependent on how you perform the reps. We want to prioritize exercises that allow us to focus on the contraction of the lats and not let the biceps take over. This in combination with progressive overload with weights and/or reps is the main driver for lat growth.")
                            .font(.body)
                            .foregroundColor(Color(red: 0.8, green: 0.8, blue: 0.8))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text("*To feel back muscles better during pull exercises focus on bringing your elbows back and scrunching your shoulders back while your chest comes forward.")
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

                            Text("Your lat growth will primarily come from compound pulling movements. We target the lats by focusing on horizontal and high to low pulling movements.")
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

                            Text("Strength Focus\n")
                                .font(.body)
                                .fontWeight(.bold)
                                .foregroundColor(.white) +
                            Text("5×5 reps (Heavier Weight)")
                                .foregroundColor(Color(red: 0.8, green: 0.8, blue: 0.8))
                            
                            Text("Hypertrophy Focus\n")
                                .font(.body)
                                .fontWeight(.bold)
                                .foregroundColor(.white) +
                            Text("3×(8-16) reps (Moderate Weight)")
                                .foregroundColor(Color(red: 0.8, green: 0.8, blue: 0.8))

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

                            Text("1. Deadlift")
                                .font(.body)
                                .foregroundColor(Color(red: 0.8, green: 0.8, blue: 0.8))
                                .frame(maxWidth: .infinity, alignment: .leading)

                            Text("2. Barbell / Dumbbell / Cable Rows")
                                .font(.body)
                                .foregroundColor(Color(red: 0.8, green: 0.8, blue: 0.8))
                                .frame(maxWidth: .infinity, alignment: .leading)

                            Text("3. Weighted Pull Ups")
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
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .leading)

                            Text("We use accessory movements to take away the emphasis on the biceps that compound movements have which allows us to strictly focus on the contraction of the lats.")
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

                            Text("Straight Sets (Normal Sets)\n")
                                .font(.body)
                                .fontWeight(.bold)
                                .foregroundColor(.white) +
                            Text("X Reps → Rest 3 Min")
                                .foregroundColor(Color(red: 0.8, green: 0.8, blue: 0.8))

                            Text("Drop Sets\n")
                                .font(.body)
                                .fontWeight(.bold)
                                .foregroundColor(.white) +
                            Text("X Reps at Y Weight → Rest\nX Reps at 0.75Y Weight → Rest\nX Reps at 0.5Y Weight → Rest")
                                .foregroundColor(Color(red: 0.8, green: 0.8, blue: 0.8))
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

                            Text("1. Lat Pull Downs")
                                .font(.body)
                                .foregroundColor(Color(red: 0.8, green: 0.8, blue: 0.8))
                                .frame(maxWidth: .infinity, alignment: .leading)

                            Text("2. Cable Lat Pullover")
                                .font(.body)
                                .foregroundColor(Color(red: 0.8, green: 0.8, blue: 0.8))
                                .frame(maxWidth: .infinity, alignment: .leading)

                            Text("*focus on squeezing back")
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
