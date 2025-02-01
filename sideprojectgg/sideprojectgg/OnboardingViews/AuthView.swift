//
//  AuthView.swift
//  sideprojectgg
//
//  Created by Jeremy Villanueva on 12/31/24.
//

import SwiftUI

struct AuthView: View {
    @EnvironmentObject var viewModel: ContentViewModel
    
    @Binding var intakeForm: IntakeForm
    @Binding var path: NavigationPath
    let generator = UIImpactFeedbackGenerator(style: .heavy)
    
    var body: some View {
        
        ZStack {
            Color(red: 15/255, green: 15/255, blue: 15/255)
                .edgesIgnoringSafeArea(.all)
            VStack { // Adjust spacing between buttons
                
                Text("Create Your Account")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: 350, alignment: .leading)
                // Google Sign-In Button
                Button(action: {
                    Task {
                        generator.impactOccurred()
                        await viewModel.signInWithGoogle(intakeForm: intakeForm)
                    }
                }) {
                    HStack {
                        Image("google_logo") // Use a custom Google logo asset
                            .resizable()
                            .aspectRatio(contentMode: .fit) // Maintain aspect ratio
                            .frame(width: 40, height: 40)
                        
                        Spacer() // Push text to center
                        
                        Text("Sign in with Google")
                            .font(.system(size: 18))
                            .foregroundColor(.black)
                            .fontWeight(.bold)
                        
                        Spacer() // Maintain centering
                        
                    }
                    .frame(maxWidth: .infinity, maxHeight: 80, alignment: .leading) // Leading align
                    .padding(.horizontal, 20) // Adjust padding
                    .background(Color.white)
                    .cornerRadius(45)
                    .shadow(radius: 2)
                    .padding()
                }
                
                // Apple Sign-In Button
                Button(action: {
                    Task {
                        generator.impactOccurred()
                        await viewModel.signInWithApple(intakeForm: intakeForm)
                    }
                }) {
                    HStack {
                        Image(systemName: "applelogo") // Apple logo fix
                            .resizable()
                            .aspectRatio(contentMode: .fit) // Maintain aspect ratio
                            .frame(width: 35, height: 35)
                            .foregroundColor(.white)
                        
                        Spacer() // Push text to center
                        
                        Text("Sign in with Apple")
                            .font(.system(size: 18))
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                        
                        Spacer() // Maintain centering
                        
                    }
                    .frame(maxWidth: .infinity, maxHeight: 80, alignment: .leading) // Leading align
                    .padding(.horizontal, 20) // Adjust padding
                    .background(Color.black)
                    .cornerRadius(45)
                    .padding()
                }
            }
            .padding()
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        path.removeLast() // Custom back button action
                        generator.impactOccurred()
                    }) {
                        HStack {
                            Image(systemName: "chevron.left") // Custom back button icon
                                .foregroundColor(.gray) // Set the color to gray
                        }
                    }
                }
            }
        }
    }
}
