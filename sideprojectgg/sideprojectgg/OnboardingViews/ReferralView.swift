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
        
        ZStack {
            Color(red: 15/255, green: 15/255, blue: 15/255)
                .edgesIgnoringSafeArea(.all)
            VStack {
                Spacer()
                Text("Enter Invite Code")
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
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1)
                            .frame(width: 350, height: 60) // Expandable hitbox
                            .contentShape(Rectangle()) // Expands the tappable area
                            .cornerRadius(10) // Round edges
                        
                        TextField("Enter your invite code", text: $referralInput)
                            .textInputAutocapitalization(.characters)
                            .padding(20) // Increase padding inside the box
                            .frame(width: 350, height: 60) // Explicitly set the size
                            .cornerRadius(10) // Round edges
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray, lineWidth: 1) // Add border
                            )
                            .onChange(of: referralInput) { newValue in
                                if newValue.count > 6 {
                                    referralInput = String(newValue.prefix(6))
                                }
                                showError = referralInput.count != 6 && referralInput.count != 0
                            }
                    }
                    .onTapGesture {
                        // Manually trigger focus when tapping anywhere in the box
                        UIApplication.shared.sendAction(#selector(UIResponder.becomeFirstResponder), to: nil, from: nil, for: nil)
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
                                .foregroundColor(.gray)
                        }
                    }
                }
            }

        }
    }
}
