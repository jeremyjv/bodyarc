//
//  RoutineView.swift
//  sideprojectgg
//
//  Created by Jeremy Villanueva on 1/10/25.
//

import SwiftUI

struct RoutineView: View {
    // Accept a custom order of muscles as a list of strings
    let muscleOrder: [String]

    @State private var selectedMuscle: MuscleGroup? = nil // Track selected muscle group

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Your Growth Strategy")
                    .font(.largeTitle)
                    .bold()
                    .padding(.horizontal)

                ForEach(muscleOrder, id: \.self) { muscleName in
                    if let muscle = MuscleGroup(rawValue: muscleName) {
                        Button(action: {
                            selectedMuscle = muscle
                        }) {
                            Text("Show \(muscle.rawValue) Routine")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding(.horizontal)
                    } else {
                        // Handle invalid muscle names gracefully
                        Text("Invalid Muscle: \(muscleName)")
                            .font(.caption)
                            .foregroundColor(.red)
                            .padding(.horizontal)
                    }
                }
            }
            .padding(.vertical)
        }
        .sheet(item: $selectedMuscle) { muscle in
            muscle.view
                .presentationDetents([.fraction(0.95)]) // Custom detents
                .presentationDragIndicator(.visible) // Shows drag indicator
        }
    }
}

// Enum for muscle groups with associated views
enum MuscleGroup: String, CaseIterable, Identifiable {
    case shoulders = "Shoulders"
    case chest = "Chest"
    
    
    var id: String { rawValue } // Conform to Identifiable
    
    // Return the corresponding view for each muscle group
    var view: some View {
        switch self {
        case .shoulders:
            return AnyView(ShoulderRoutineView())
        case .chest:
            return AnyView(ShoulderRoutineView())
            
        }
    }
}

#Preview {

}
