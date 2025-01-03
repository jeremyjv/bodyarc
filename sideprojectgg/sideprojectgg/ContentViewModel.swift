//
//  ContentViewModel.swift
//  sideprojectgg
//
//  Created by Jeremy Villanueva on 12/7/24.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseFunctions
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth
import GoogleSignIn


@MainActor
class ContentViewModel: ObservableObject {
    
    
    //Original data
    @Published var text: String = ""
    @Published var frontImage: UIImage?
    @Published var backImage: UIImage?
    
    //these should change when we run the analysis
    @Published var frontAnalysisJSON: Data?
        
    @Published var backAnalysisJSON: Data?
    
    // Initial value for frontAnalysis and backAnalysis (will be updated by didSet observers)
    @Published var frontAnalysis: FrontAnalysis?
    @Published var backAnalysis: BackAnalysis?
    
    let db = Firestore.firestore()
    
    //Auth view model data
    
    @Published var email: String?
    @Published var uid: String?
    @Published var isLoggedIn = false
    
    private var authStateListenerHandle: AuthStateDidChangeListenerHandle?
    
 
    
    init() {
        self.authStateListenerHandle = Auth.auth().addStateDidChangeListener { [weak self] auth, user in
                        self?.isLoggedIn = user != nil
                    }
        self.email = Auth.auth().currentUser?.email
        self.uid = Auth.auth().currentUser?.uid
    }
    deinit {
        if let handle = authStateListenerHandle {
            Auth.auth().removeStateDidChangeListener(handle)
            }
        }
    
    
        
    let functions = Functions.functions()
    
    func signOut() {
            do {
                try Auth.auth().signOut()
                isLoggedIn = false
            } catch {
                print("Error signing out: \(error.localizedDescription)")
            }
        }
    
    func signInWithGoogle(intakeForm: IntakeForm) async -> Bool {
        
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
            
            //maybe add new user to Firestore Here:
            let userData: [String: Any] = [
                "uid": firebaseUser.uid,
                "email": firebaseUser.email as Any,
                "gender": intakeForm.gender as Any,
                "goal": intakeForm.goal as Any,
                "availability": intakeForm.availability as Any
                    
            ]
            
            //firestore already disregards duplicate UID so if it already exists, it doesn't add it
            
            
            //want to add intake form data aswell when creating user
            Functions.functions().useEmulator(withHost: "http://127.0.0.1", port: 5001)
            
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
    
    
    //whole step to 
    func handleScanUploadAction() {
        Task {
            // Ensure images are not nil
            guard let frontImage = self.frontImage, let backImage = self.backImage else {
                print("Images are missing")
                return
            }
            
            //compute front and back analysis
            await self.createFrontAnalysis(img: frontImage)
            await self.createBackAnalysis(img: backImage)

            // Convert and upload images
            var frontImageURL: String?
            let frontImageData = self.convertImagePNGData(img: frontImage)
            await self.uploadFile(data: frontImageData, path: "images/front_image.png") { result in
                switch result {
                case .success(let downloadURL):
                    //frontImageURL = downloadURL
                    frontImageURL = downloadURL.absoluteString
                    print("Upload successful! URL: \(downloadURL)")
                case .failure(let error):
                    print("Upload failed: \(error.localizedDescription)")
                }
            }
            
            //then upload url
            var backImageURL: String?
            let backImageData = self.convertImagePNGData(img: backImage)
            await self.uploadFile(data: backImageData, path: "images/back_image.png") { result in
                switch result {
                case .success(let downloadURL):
                    
                    backImageURL = downloadURL.absoluteString
                    print("Upload successful! URL: \(downloadURL)")
                case .failure(let error):
                    print("Upload failed: \(error.localizedDescription)")
                }
            }
            
            //now that we have the images and analysis, store as a scan in scan collection with the user's UID (so we have to reference AuthViewModel asweell)
            let scan = ScanObject(userUID: self.uid, frontImage: frontImageURL, backImage: backImageURL, frontAnalysis: self.frontAnalysis,backAnalysis: self.backAnalysis)
            
            
            do {
              try db.collection("scans").document().setData(from: scan)
            } catch let error {
              print("Error writing city to Firestore: \(error)")
            }
            
            //store all data in Scan Struct then add to firebase
            
            
            
            
        }
    }
    
    func convertImageToBase64(img: UIImage) -> String {
        return img.jpegData(compressionQuality: 1)!.base64EncodedString()
    }
    func convertImagePNGData(img: UIImage) -> Data {
        return img.pngData()!
    }
    //Firebase STORAGE///
    
    //when we save scan, we save the images and pass it to here to receive back a URL that points back to it
    func uploadFile(data: Data, path: String, completion: @escaping (Result<URL, Error>) -> Void) async {
        let storage = Storage.storage()
        let storageRef = storage.reference().child(path)
        
        storageRef.putData(data, metadata: nil) { metadata, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            storageRef.downloadURL { url, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                if let url = url {
                    completion(.success(url))
                }
            }
        }
    }
    
    
    
    //CLOUD FUNCTIONS //
    
    
    func callHelloWorld() async -> String {
        Functions.functions().useEmulator(withHost: "http://127.0.0.1", port: 5001)
        var text = "hello"
        functions.httpsCallable("helloWorld").call { result, error in
            
            if let error = error {
                print("Error calling function: \(error)")
                return
            }
            if let data = result?.data as? String {
               
                text = data
                print("text:", self.text)
                print("Function response: \(data)")
            }
        }
        
        return text
    }
    
    
    // make separate analysis function for front and back analysis
    func createFrontAnalysis(img: UIImage) async {
        let base64 = self.convertImageToBase64(img: img)
        
        //let data: [String: Any] = ["base64": base64] // Your arguments
        Functions.functions().useEmulator(withHost: "http://127.0.0.1", port: 5001)
 
        functions.httpsCallable("returnFrontAnalysis").call(base64) { result, error in
            
            if let error = error {
                print("Error calling function: \(error)")
                return
            }
            if let data = result?.data as? String {
                
                Task { [weak self] in
                    guard let self else {return}
                    
                    do {
                        frontAnalysisJSON = data.data(using: .utf8)
                        let decoder = JSONDecoder()
                        frontAnalysis = try decoder.decode(FrontAnalysis.self, from: frontAnalysisJSON!)
                    } catch {
                        print("Error decoding JSON: \(error)")
                    }
                }
              
               
                print("Function response: \(data)")
            }
        }
  
    }
    
    func createBackAnalysis(img: UIImage) async {
        let base64 = self.convertImageToBase64(img: img)
        
        //let data: [String: Any] = ["base64": base64] // Your arguments
        Functions.functions().useEmulator(withHost: "http://127.0.0.1", port: 5001)
 
        functions.httpsCallable("returnBackAnalysis").call(base64) { result, error in
            
            if let error = error {
                print("Error calling function: \(error)")
                return
            }
            if let data = result?.data as? String {
                
                Task { [weak self] in
                    guard let self else {return}
                    
                    do {
                        backAnalysisJSON = data.data(using: .utf8)
                        let decoder = JSONDecoder()
                        backAnalysis = try decoder.decode(BackAnalysis.self, from: backAnalysisJSON!)
                    } catch {
                        print("Error decoding JSON: \(error)")
                    }
                }
              
            
                print("Function response: \(data)")
            }
        }
  
    }
    
}
