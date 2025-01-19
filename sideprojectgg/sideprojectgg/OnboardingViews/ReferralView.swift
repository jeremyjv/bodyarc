//
//  ReferralView.swift
//  sideprojectgg
//
//  Created by Jeremy Villanueva on 1/18/25.
//
import SwiftUI

struct ReferralView: View {
    @Binding var intakeForm: IntakeForm
    @Binding var path: NavigationPath
    let generator = UIImpactFeedbackGenerator(style: .heavy)
    
    @State private var referralInput: String = "" // Local state for the text input
    
    
    var body: some View {
        
        //set intakeForm.referralCode equal to input
        
        VStack {
            Text("Enter Referral Code")
                .font(.largeTitle) // Make font larger
                .fontWeight(.bold) // Make text bold
                .foregroundColor(.white) // Text color
                .frame(maxWidth: 350, alignment: .leading)
            
            Spacer().frame(height: 60)
            TextField("Enter your referral code", text: $referralInput)
                .textFieldStyle(RoundedBorderTextFieldStyle()) // Rounded style for input
                .textInputAutocapitalization(.characters) // Force uppercase input
                .padding()
                .frame(maxWidth: 350) // Width of the text field
            
       
            Button(action: {
                intakeForm.referralCode = referralInput.uppercased() // Assign the input value to referralCode and always make sure it is uppercased
                path.append("AuthView")
                generator.impactOccurred()
            }){
                CustomButton(title: "Continue")
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
