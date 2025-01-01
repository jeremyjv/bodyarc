//
//  AuthView.swift
//  sideprojectgg
//
//  Created by Jeremy Villanueva on 12/31/24.
//

import SwiftUI


struct AuthView: View {
    @StateObject private var authViewModel = AuthViewModel()
    
    
    
    var body: some View {
        VStack {
            
            //Trigger Auth Logic here -> triggers event to create new user in Firestore
            Button(action: {
                Task {
                    await authViewModel.signInWithGoogle()
                }
             
            }) {
                Text("Sign In with Google")
            }
            Text("Sign In with Apple")
        }
    }
    
}
