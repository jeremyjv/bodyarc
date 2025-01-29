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
    
    

    
    var body: some View {
        VStack {
            
            //Trigger Auth Logic here -> triggers event to create new user in Firestore
            Button(action: {
                Task {
                    
                    //pass intake form data to this function and if user created add form to their user model
                    await viewModel.signInWithGoogle(intakeForm: intakeForm)
                    
                    
                    //dump the navigation path then navigate to ContentView
                    
                    
                    //pass in intake form to store in created user
                }
             
            }) {
                Text("Sign In with Google")
            }
            Button(action: {
                Task {
                    
                    //pass intake form data to this function and if user created add form to their user model
                    await viewModel.signInWithApple(intakeForm: intakeForm)
                    
                    
                    //dump the navigation path then navigate to ContentView
                    
                    
                    //pass in intake form to store in created user
                }
             
            }) {
                Text("Sign In with Apple")
            }
        }
    }
    
}
