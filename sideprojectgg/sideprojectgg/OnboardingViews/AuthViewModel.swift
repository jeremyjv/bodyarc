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
import FirebaseFunctions
import Firebase

//Create Navigation stack here that goes through onboarding views

//use this model to get all info needed about user (UID to access FireStore etc.) 

class AuthViewModel: ObservableObject {
    @Published var email: String?
    @Published var uid = ""
    @Published var isLoggedIn = false
    
    private var authStateListenerHandle: AuthStateDidChangeListenerHandle?
    
    
    init() {
        self.authStateListenerHandle = Auth.auth().addStateDidChangeListener { [weak self] auth, user in
                        self?.isLoggedIn = user != nil
                    }
        self.email = Auth.auth().currentUser!.email
    }
    deinit {
        if let handle = authStateListenerHandle {
            Auth.auth().removeStateDidChangeListener(handle)
            }
        }
    
    
    let functions = Functions.functions()
    func signInWithGoogle() async -> Bool {
        
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            fatalError("")
        }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        guard let windowScene = await UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = await windowScene.windows.first,
              let rootViewController = await window.rootViewController else {
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
            
            //maybe add new user to Firestore Here:
            let userData: [String: Any] = [
                "uid": firebaseUser.uid,
                "email": firebaseUser.email as Any,
            ]
            
            //firestore already disregards duplicate UID so if it already exists, it doesn't add it
            
            Functions.functions().useEmulator(withHost: "http://10.0.0.101", port: 5001)
            
            functions.httpsCallable("createNewUser").call(userData) { result, error in
                
                if let error = error {
                    print("Error calling function: \(error)")
                    return
                }
                print("added user \(firebaseUser.uid) to firestore")
            }
            
            //want to redirect to GoalsView
            isLoggedIn = true
            
            print("User \(firebaseUser.uid) signed in with \(firebaseUser.email ?? "unknown")")
            
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
        
        
    }
  
}


