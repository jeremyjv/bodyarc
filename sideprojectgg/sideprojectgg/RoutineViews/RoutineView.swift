//
//  RoutineView.swift
//  sideprojectgg
//
//  Created by Jeremy Villanueva on 1/10/25.
//

import SwiftUI
import FirebaseFirestore


//need case where if user does not have scan, Direct them to Scan View
struct RoutineView: View {
    
    @EnvironmentObject var viewModel: ContentViewModel
    @State private var hasLoadedData = false
    var muscleRankings = ["Shoulders", "Chest", "Traps", "Lats", "Arms", "Abs"]
    @State private var selectedMuscle: MuscleGroup? = nil // Track selected muscle group
    @State private var isNutritionViewPresented = false // Track if NutritionView is presented
    
    let generator = UIImpactFeedbackGenerator(style: .heavy)
    
    //if user has no scans put "Scan to get Growth Strategies"
    

    var body: some View {
        ZStack {
            Color(red: 15/255, green: 15/255, blue: 15/255)
                .edgesIgnoringSafeArea(.all) // Ensures it covers the entire screen
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Nutrition Section
                    Text("Growth Strategies")
                        .font(.largeTitle)
                        .bold()
                        .padding(.horizontal)
                        .foregroundColor(.white)
                    
                    // Nutrition Section with Button
                    Text("Nutrition 🍗")
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                        .foregroundColor(.white)
                    
                    Button(action: {
                        generator.impactOccurred()
                        isNutritionViewPresented = true
                    }) {
                        Rectangle()
                            .fill(Color.gray.opacity(0.1))
                            .frame(height: 100)
                            .cornerRadius(10)
                            .overlay(
                                HStack {
                                    Text("Calories + Macros")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.white)
                                }
                                .padding()
                               
                            )
                    }
                    .padding(.horizontal)
                    
                    // Training Styles Section
                    Text("Training 🏋🏽")
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                        .foregroundColor(.white)
                    
                    ForEach(muscleRankings, id: \.self) { muscleName in
                        if let muscle = MuscleGroup(rawValue: muscleName) {
                            Button(action: {
                                generator.impactOccurred()
                                selectedMuscle = muscle
                            }) {
                                HStack {
                                    Text(muscle.rawValue)
                                        .font(.headline)
                                        .foregroundColor(.white)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.white)
                                }
                                .padding()
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(10)
                            }
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
            .sheet(isPresented: $isNutritionViewPresented) {
                NutritionRoutineView()
                    .presentationDetents([.fraction(0.95)]) // Custom detents
                    .presentationDragIndicator(.visible) // Shows drag indicator
            }
        }
    }
}

// Enum for muscle groups with associated views
enum MuscleGroup: String, CaseIterable, Identifiable {
    case shoulders = "Shoulders"
    case chest = "Chest"
    case arms = "Arms"
    case abs = "Abs"
    case traps = "Traps"
    case lats = "Lats"

    var id: String { rawValue } // Conform to Identifiable
    
    // Return the corresponding view for each muscle group
    var view: some View {
        switch self {
        case .shoulders:
            return AnyView(ShoulderRoutineView())
        case .chest:
            return AnyView(ChestRoutineView())
        case .arms:
            return AnyView(ArmsRoutineView())
        case .abs:
            return AnyView(AbsRoutineView())
        case .traps:
            return AnyView(TrapsRoutineView())
        case .lats:
            return AnyView(LatsRoutineView())
        }
    }
}


#Preview {

}
