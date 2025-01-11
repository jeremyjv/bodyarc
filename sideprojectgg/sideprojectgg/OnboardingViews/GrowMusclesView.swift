//
//  GrowMusclesView.swift
//  sideprojectgg
//
//  Created by Jeremy Villanueva on 1/10/25.
//

import SwiftUI

//store goals into struct then we can save it for them when they auth
struct GrowMusclesView: View {
    @Binding var intakeForm: IntakeForm
    @Binding var path: NavigationPath
    let generator = UIImpactFeedbackGenerator(style: .heavy)
    
    
    var body: some View {
        
        VStack {
            Text("What muscles do you want to grow")
                .font(.largeTitle) // Make font larger
                .fontWeight(.bold) // Make text bold
                .foregroundColor(.white) // Text color
                .frame(maxWidth: 350, alignment: .leading)
            
            Spacer().frame(height: 60)
            
            Button(action: {
                path.append("GoalsView")
                intakeForm.goal = "loseFat"
                generator.impactOccurred()
            }){
                CustomButton(title: "Shoulders", emoji: "")
            }
            Button(action: {
                path.append("GoalsView")
                intakeForm.goal = "buildMuscle"
                generator.impactOccurred()
            }){
             
                CustomButton(title: "Chest", emoji: "💪")
            }
            Button(action: {
                path.append("GoalsView")
                intakeForm.goal = "bodyRecomp"
                generator.impactOccurred()
            }){
                CustomButton(title: "Arms", emoji: "💪")
            }
            Button(action: {
                path.append("GoalsView")
                intakeForm.goal = "healthierHabits"
                generator.impactOccurred()
            }){
                CustomButton(title: "Back", emoji: "🍃")
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    path.removeLast() // Custom back button action
                    generator.impactOccurred()
                }) {
                    HStack {
                        Image(systemName: "chevron.left") // Custom back button icon
                    }
                }
            }
        }
        
    }
    
    
}
