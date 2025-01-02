//
//  AuthView.swift
//  sideprojectgg
//
//  Created by Jeremy Villanueva on 12/31/24.
//

import SwiftUI


struct AuthView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @Binding var intakeForm: IntakeForm
    @Binding var path: NavigationPath
    

    
    var body: some View {
        VStack {
            
            //Trigger Auth Logic here -> triggers event to create new user in Firestore
            Button(action: {
                Task {
                    
                    await authViewModel.signInWithGoogle()
                    
                    
                    //dump the navigation path then navigate to ContentView
                    
                    
                    //pass in intake form to store in created user
                }
             
            }) {
                Text("Sign In with Google")
            }
            Text("Sign In with Apple")
        }
    }
    
}
