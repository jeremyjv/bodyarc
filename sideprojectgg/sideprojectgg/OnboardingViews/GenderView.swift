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
    
    
    
    var body: some View {
        
        
        NavigationStack(path: $path) {
            Text("Select Gender")
            
            VStack {
                Button(action: {
                    path.append("GoalsView")
                    intakeForm.gender = "male"
                }){
                    CustomButton(title: "male")
                }
                Button(action: {
                    path.append("GoalsView")
                    intakeForm.gender = "female"
                }){
                    CustomButton(title: "female")
                }

            }
            .navigationDestination(for: String.self) { destination in
                switch destination {
                    case "GoalsView":
                        GoalsView(intakeForm: $intakeForm, path: $path)
                    case "AvailabilityView":
                        AvailabilityView(intakeForm: $intakeForm, path: $path)
                    case "AuthView":
                        AuthView(intakeForm: $intakeForm, path: $path)
                        
                    default:
                        GenderView()
                    }
                
            }
            
        }
        
    }
}

struct CustomButton: View {
    var title: String
    var body: some View {
        
        Text(title)
            .font(.headline)
            .frame(maxWidth: .infinity) // Make button fill the width
            .padding() // Add padding inside the button
            .background(Color.blue) // Set button background
            .cornerRadius(8) // Rounded corners
            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2) // Shadow
            .foregroundColor(.white) // Text color
    }
}

#Preview {
 
}
