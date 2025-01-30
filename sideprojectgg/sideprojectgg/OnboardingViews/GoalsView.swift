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
    let generator = UIImpactFeedbackGenerator(style: .heavy)
    
    
    var body: some View {
        
        ZStack {
            Color(red: 15/255, green: 15/255, blue: 15/255)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("Fitness goals over the next 3 months?")
                    .font(.largeTitle) // Make font larger
                    .fontWeight(.bold) // Make text bold
                    .foregroundColor(.white) // Text color
                    .frame(maxWidth: 350, alignment: .leading)
                
                Spacer().frame(height: 60)
                
                Button(action: {
                    path.append("ReferralView")
                    intakeForm.goal = "loseFat"
                    generator.impactOccurred()
                }){
                    CustomButton(title: "Lose Fat", emoji: "🔥")
                }
                Button(action: {
                    path.append("ReferralView")
                    intakeForm.goal = "buildMuscle"
                    generator.impactOccurred()
                }){
                    
                    CustomButton(title: "Build Muscle", emoji: "💪")
                }
                Button(action: {
                    path.append("ReferralView")
                    intakeForm.goal = "bodyRecomp"
                    generator.impactOccurred()
                }){
                    CustomButton(title: "Lose Fat + Build Muscle", emoji: "😈")
                }
                Button(action: {
                    path.append("ReferralView")
                    intakeForm.goal = "healthierHabits"
                    generator.impactOccurred()
                }){
                    CustomButton(title: "Build Healthier Habits", emoji: "🍃")
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
}

#Preview {
  
}
