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
            
            Button(action: {
                path.append("GoalsView")
            }){
                Text("Continue")
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

#Preview {
 
}
