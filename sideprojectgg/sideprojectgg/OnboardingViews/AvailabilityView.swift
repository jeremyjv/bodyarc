//
//  AvailabilityView.swift
//  sideprojectgg
//
//  Created by Jeremy Villanueva on 1/1/25.
//

import SwiftUI

struct AvailabilityView: View {
    
    @Binding var intakeForm: IntakeForm
    @Binding var path: NavigationPath
    @State private var selectedValue: Int = 4 // Initial value (default to 4)
    let totalPoints = 7 // Total number of points
    let sliderWidth: CGFloat = 300 // Maximum width of the slider

    var body: some View {
        VStack(spacing: 30) {
            // Display the selected value
            Text("Selected Value: \(selectedValue)")
                .font(.headline)

            // Custom slider
            GeometryReader { geometry in
                let stepWidth = sliderWidth / CGFloat(totalPoints - 1) // Space between dots
                
                ZStack {
                    // Slider Line
                    Rectangle()
                        .fill(Color.gray.opacity(0.5))
                        .frame(width: sliderWidth, height: 4)
                    
                    // Dots
                    HStack(spacing: stepWidth) {
                        ForEach(1...totalPoints, id: \.self) { value in
                            Circle()
                                .fill(value == selectedValue ? Color.blue : Color.gray)
                                .frame(width: 20, height: 20)
                                .onTapGesture {
                                    selectedValue = value // Update the selected value
                                }
                        }
                    }

                    // Draggable indicator
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 30, height: 30)
                        .offset(x: CGFloat(selectedValue - 1) * stepWidth - sliderWidth / 2)
                        .gesture(
                            DragGesture()
                                .onChanged { gesture in
                                    // Calculate the new value based on the drag position
                                    let startX = (geometry.size.width - sliderWidth) / 2
                                    let dragX = gesture.location.x - startX
                                    let index = Int((dragX / stepWidth).rounded())
                                    selectedValue = min(max(index + 1, 1), totalPoints)
                                }
                        )
                }
                .frame(width: geometry.size.width, height: 50) // Ensure proper sizing
            }
            .frame(height: 50) // GeometryReader height
        }
        .frame(maxWidth: sliderWidth + 40) // Padding around the slider
        .padding()
    }
}

#Preview {
   
}
