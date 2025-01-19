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
    @State private var showError: Bool = false // Track if an error should be shown
    
    
    var body: some View {
        
        //set intakeForm.referralCode equal to input
        
        VStack {
            Text("Enter Referral Code")
                .font(.largeTitle) // Make font larger
                .fontWeight(.bold) // Make text bold
                .foregroundColor(.white) // Text color
                .frame(maxWidth: 350, alignment: .leading)
            
            Spacer().frame(height: 60)
            // TextField for referral code
            TextField("Enter your referral code", text: $referralInput)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .textInputAutocapitalization(.characters) // Force uppercase input
                .padding()
                .frame(maxWidth: 350)
                .onChange(of: referralInput) { newValue, _ in
                    // Trim the input to 6 characters
                    if newValue.count > 6 {
                        referralInput = String(newValue.prefix(6))
                    }
                    // Validate if length is exactly 6
                    showError = referralInput.count != 6 && referralInput.count != 0
                }
            
            Text("Or Continue and Skip")
                .foregroundColor(.gray)
                .font(.footnote)
                .frame(maxWidth: 350, alignment: .leading)
                .padding(.top, 5)

            // Error message
            if showError {
                Text("Referral codes are 6 characters.")
                    .foregroundColor(.red)
                    .font(.footnote)
                    .frame(maxWidth: 350, alignment: .leading)
                    .padding(.top, 5)
            }
            
       
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
