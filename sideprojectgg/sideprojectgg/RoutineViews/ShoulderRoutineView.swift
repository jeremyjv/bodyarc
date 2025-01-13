//
//  ShoulderRoutineView.swift
//  sideprojectgg
//
//  Created by Jeremy Villanueva on 1/10/25.
//

import SwiftUI


struct ShoulderRoutineView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 20) {
                // Title
                Text("Shoulders")
                    .font(.largeTitle)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top)

                // Goal Section
                VStack(alignment: .leading, spacing: 10) {
                    Text("Goal:")
                        .font(.headline)
                        .bold()
                    Text("Train shoulders with higher volume and intensity to grow the width of the upper body. (Adjust weight and volume accordingly)")
                    Text("*Always control the weight to maximize growth")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .padding()
                .frame(maxWidth: 350) // Set consistent width
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.black, lineWidth: 1)
                )

                // Lateral Raises Section
                VStack(alignment: .leading, spacing: 10) {
                    Text("Lateral Raises:")
                        .font(.headline)
                        .bold()
                    Text("Rest Pause Set Example:")
                    Text("16 Reps → Wait 10s → 8 Reps")
                        .font(.body)
                    Text("Drop Set Example:")
                    Text("8 reps 30lbs → 8 reps 25lbs → Failure")
                        .font(.body)
                    Text("*Always control weight on the way down")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .padding()
                .frame(maxWidth: 350) // Set consistent width
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.black, lineWidth: 1)
                )

                // Rear Delt Flies Section
                VStack(alignment: .leading, spacing: 10) {
                    Text("Rear Delt Flies:")
                        .font(.headline)
                        .bold()
                    Text("*Requires more volume for growth than other muscles")
                        .font(.body)
                }
                .padding()
                .frame(maxWidth: 350) // Set consistent width
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.black, lineWidth: 1)
                )
            }
            .frame(maxWidth: .infinity) // Center content horizontally
            .padding(.bottom)
        }
        .presentationDetents([.fraction(0.9)])
        .presentationDragIndicator(.visible)
    }
}

#Preview {
    ShoulderRoutineView()
}
