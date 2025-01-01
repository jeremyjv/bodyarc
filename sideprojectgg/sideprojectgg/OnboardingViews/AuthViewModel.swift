//
//  AuthViewModel.swift
//  sideprojectgg
//
//  Created by Jeremy Villanueva on 1/1/25.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

struct AuthViewModel: View {
    
    func signInWithGoogle() async -> Bool {
        
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            fatalError("")
        }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first,
              let rootViewController = window.rootViewController else {
            print("There is no root view controller")
            return false
        }
        do {
            let userAuthentication = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
            let user = userAuthentication.user
            guard let idToken = user.idToken else {
                print("token id missing")
                return false
            }
            let accessToken = user.accessToken
            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: accessToken.tokenString)
            let result = try await Auth.auth().signIn(with: credential)
            
            let firebaseUser = result.user
            print("User \(firebaseUser.uid) signed in with \(firebaseUser.email ?? "unknown")")
            
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
        
        
    }
    var body: some View {
        VStack {
            
            //Trigger Auth Logic here -> triggers event to create new user in Firestore
            Button(action: {
                Task {
                    await signInWithGoogle()
                }
             
            }) {
                Text("Sign In with Google")
            }
            Text("Sign In with Apple")
        }
    }
}

#Preview {
    AuthViewModel()
}
