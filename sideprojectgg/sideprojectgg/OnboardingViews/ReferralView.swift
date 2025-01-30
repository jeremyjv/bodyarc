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
        
        VStack {
            Spacer()
            Text("Enter Referral Code")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(maxWidth: 350, alignment: .leading)
            

            VStack(spacing: 5) { // Reduce spacing
                // Error message
                if showError {
                    Text("Referral codes are 6 characters.")
                        .foregroundColor(.red)
                        .font(.footnote)
                        .frame(maxWidth: 350, alignment: .leading)
                        .padding(.top, 5)
                }
                TextField("Enter your referral code", text: $referralInput)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .textInputAutocapitalization(.characters)
                    .padding(.horizontal)
                    .frame(maxWidth: 350, minHeight: 100) // Increase height here
                    .onChange(of: referralInput) { newValue, _ in
                        if newValue.count > 6 {
                            referralInput = String(newValue.prefix(6))
                        }
                        showError = referralInput.count != 6 && referralInput.count != 0
                    }
                
                // "Or Continue and Skip" directly below input box
                Text("Or continue and skip")
                    .foregroundColor(.gray)
                    .font(.footnote)
                    .frame(maxWidth: 350, alignment: .trailing)
            }


            Button(action: {
                intakeForm.referralCode = referralInput.uppercased()
                path.append("AuthView")
                generator.impactOccurred()
            }) {
                CustomButton(title: "Continue")
            }
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    path.removeLast()
                    generator.impactOccurred()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                    }
                }
            }
        }
    }
}
