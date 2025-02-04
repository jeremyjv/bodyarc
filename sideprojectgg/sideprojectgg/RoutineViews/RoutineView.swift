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
    @State private var loadingScreen = true  // Show "Loading..." while fetching scans
    @State private var hasScans = false  // Track if the user has scans
    @Binding var path: NavigationPath
    
    var muscleRankings = ["Shoulders", "Chest", "Traps", "Lats", "Arms", "Abs"]
    @State private var selectedMuscle: MuscleGroup? = nil
    @State private var isNutritionViewPresented = false
    
    let generator = UIImpactFeedbackGenerator(style: .heavy)

    /// Fetch user scans to check if they exist
    func fetchScans() async {
        do {
            let scans = try await viewModel.fetchScanObjects()
            DispatchQueue.main.async {
                self.hasScans = !(scans.isEmpty)  // If scans exist, update state
                self.loadingScreen = false  // Stop loading screen
                viewModel.scans = scans
            }
        } catch {
            print("Error fetching scans: \(error)")
            DispatchQueue.main.async {
                self.loadingScreen = false  // Stop loading screen on error
            }
        }
    }

    var body: some View {
        ZStack {
            Color(red: 15/255, green: 15/255, blue: 15/255)
                .edgesIgnoringSafeArea(.all)
    

            VStack(alignment: .leading, spacing: 0) {
                Text("Growth Strategies")
                    .font(.largeTitle)
                    .bold()
                    .padding(.horizontal)
                    .padding(.top, 20)
                    .foregroundColor(.white)

                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        if loadingScreen {
                            // Show "Loading..." while checking for scans
                            VStack {
                                Spacer()
                                Text("Loading...")
                                    .foregroundColor(.white)
                                    .font(.title2)
                                    .bold()
                                    .multilineTextAlignment(.center)
                                Spacer()
                            }
                            .frame(maxWidth: .infinity, minHeight: 400)
                        } else if viewModel.scans!.isEmpty && !viewModel.isScanProcessing {
                            // Show message if user has no scans
                            VStack {
                                Spacer()

                                Button(action: {
                                    generator.impactOccurred() // Haptic feedback
                                    path.append("FrontInstructionsView") // Navigate to FrontInstructionsView
                                }) {
                                    HStack {
                                        Spacer()
                                        VStack(alignment: .leading, spacing: 8) {
                                            Text("Scan to get your growth strategies")
                                                .font(.headline)
                                                .foregroundColor(.white)
                                                .bold()
                            
                                        }
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(.white)
                                    }
                                    .padding()
                                    .frame(height: 100)
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(12)
                                    .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                                }
                                .buttonStyle(PlainButtonStyle())
                                .padding(.horizontal)

                                Spacer()
                            }
                            .frame(maxWidth: .infinity, minHeight: 400)
                        } else {
                            // Nutrition Section
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
                            
                            // Training Section
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
                    }
                    .padding(.vertical)
                }
            }
            .onAppear {
                if !hasLoadedData {
                    hasLoadedData = true
                    Task { await fetchScans() }
                }
            }
            .sheet(item: $selectedMuscle) { muscle in
                muscle.view
                    .presentationDetents([.fraction(0.95)])
                    .presentationDragIndicator(.visible)
            }
            .sheet(isPresented: $isNutritionViewPresented) {
                NutritionRoutineView()
                    .presentationDetents([.fraction(0.95)])
                    .presentationDragIndicator(.visible)
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
