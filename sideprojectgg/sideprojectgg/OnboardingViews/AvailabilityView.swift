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
    
    
    var body: some View {
        Text("How many days can you workout per week?")
        
        
    
        
        Button(action: {
            path.append("AuthView")
            intakeForm.availability = "1"
        }){
            CustomButton(title: "1")
        }
        Button(action: {
            path.append("AuthView")
            intakeForm.availability = "2"
        }){
            CustomButton(title: "2")
        }
        Button(action: {
            path.append("AuthView")
            intakeForm.availability = "3"
        }){
            CustomButton(title: "3")
        }
        Button(action: {
            path.append("AuthView")
            intakeForm.availability = "4"
        }){
            CustomButton(title: "4")
        }
        Button(action: {
            path.append("AuthView")
            intakeForm.availability = "5"
        }){
            CustomButton(title: "5")
        }
        
        
    }
}

#Preview {
   
}
