//
//  GenderView.swift
//  sideprojectgg
//
//  Created by Jeremy Villanueva on 1/1/25.
//

import SwiftUI

struct GenderView: View {
    @State private var intakeForm = IntakeForm()
    @State private var path = NavigationPath() // To manage navigation
    let generator = UIImpactFeedbackGenerator(style: .heavy)
    
    
    
    var body: some View {
        
        
        NavigationStack(path: $path) {
            
            ZStack {
                Color(red: 15/255, green: 15/255, blue: 15/255)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    // "Select Gender" text
                    Spacer()
                    Text("Select Gender")
                        .font(.largeTitle) // Make font larger
                        .fontWeight(.bold) // Make text bold
                        .foregroundColor(.white) // Text color
                        .frame(maxWidth: 350, alignment: .leading)
                    
                    Spacer().frame(height: 60)
                    
                    // Buttons
                    VStack(spacing: 25) { // Add spacing between buttons
                        Button(action: {
                            path.append("GoalsView")
                            intakeForm.gender = "male"
                            generator.impactOccurred()
                        }) {
                            CustomButton(title: "Male")
                        }
                        
                        Button(action: {
                            path.append("GoalsView")
                            intakeForm.gender = "female"
                            generator.impactOccurred()
                        }) {
                            CustomButton(title: "Female")
                        }
                    }
                    Spacer() // Add spacer below the buttons
                }
                .navigationDestination(for: String.self) { destination in
                    switch destination {
                    case "GoalsView":
                        GoalsView(intakeForm: $intakeForm, path: $path)
                        
                    case "AuthView":
                        AuthView(intakeForm: $intakeForm, path: $path)
                        
                    case "ReferralView":
                        ReferralView(intakeForm: $intakeForm, path: $path)
                        
                        
                    default:
                        GenderView()
                    }
                    
                }
            }
            
        }
            
        
    }
}

struct CustomButton: View {
    var title: String
    var emoji: String? // Add emoji as a parameter

    var body: some View {
        HStack {
            Text(title) // Button title
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.white) // Text color
            
            Spacer() // Push emoji to the right
            
            if emoji != nil {
                Text(emoji!) // Emoji
                    .font(.title2)
            }
        }
        .frame(maxWidth: 300, minHeight: 40) // Set button dimensions
        .padding() // Add padding inside the button
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color(red: 4/255, green: 96/255, blue: 255/255), Color(red: 4/255, green: 180/255, blue: 255/255)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(8) // Rounded corners
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2) // Shadow
    }
}

#Preview {
    GenderView()
}
