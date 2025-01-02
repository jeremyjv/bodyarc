//
//  GoalsView.swift
//  sideprojectgg
//
//  Created by Jeremy Villanueva on 1/1/25.
//

import SwiftUI


//store goals into struct then we can save it for them when they auth
struct GoalsView: View {
    @Binding var intakeForm: IntakeForm
    @Binding var path: NavigationPath
    
    
    var body: some View {
        Text("What are your fitness and health goals over the next 6 months?")
        
        Button(action: {
            path.append("AvailabilityView")
            intakeForm.goal = "loseFat"
        }){
            CustomButton(title: "Lose Fat")
        }
        Button(action: {
            path.append("AvailabilityView")
            intakeForm.goal = "buildMuscle"
        }){
         
            CustomButton(title: "Build Muscle")
        }
        Button(action: {
            path.append("AvailabilityView")
            intakeForm.goal = "bodyRecomp"
        }){
            CustomButton(title: "Body Recomp (Lose Fat and Build Muscle)")
        }
        Button(action: {
            path.append("AvailabilityView")
            intakeForm.goal = "healthierHabits"
        }){
            CustomButton(title: "Build Healthier Habits")
        }
        
    
    }
}

#Preview {
  
}
