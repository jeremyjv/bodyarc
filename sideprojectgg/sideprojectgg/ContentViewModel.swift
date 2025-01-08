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
    @Published var frontImageURL: String?
    @Published var backImageURL: String?
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
            
            //store data as struct then pass to firebase
            
            let userModel = User(email: firebaseUser.email, uid: firebaseUser.uid, intake: intakeForm)
            
            do {
                try db.collection("users").addDocument(from: userModel)
                print("added user \(firebaseUser.uid) to firestore")
            } catch let error {
                print("Error writing user to Firestore: \(error)")
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
    

    
    
    //we can delegate this server side instead to fix
    @MainActor
    func handleScanUploadAction() async {
        
        
        // Ensure images are not nil
        guard let frontImage = self.frontImage, let backImage = self.backImage else {
            print("Images are missing")
            return
        }
        
        //compute front and back analysis

        
        
        do {
            
     
            try await self.createFrontAnalysis(img: frontImage)
            try await self.createBackAnalysis(img: backImage)
            
    
          
            // Convert and upload images
            // Upload front and back images sequentially
            let frontImageData = self.convertImagePNGData(img: frontImage)
            let uuid1 = NSUUID().uuidString
            self.frontImageURL = try await self.uploadFile(data: frontImageData, path: "images/\(uuid1).png").absoluteString
            
            let backImageData = self.convertImagePNGData(img: backImage)
            let uuid2 = NSUUID().uuidString
            self.backImageURL = try await self.uploadFile(data: backImageData, path: "images/\(uuid2).png").absoluteString
        } catch let error {
            print("Error to Firestore: \(error)")
        }
        
        
        guard let frontImageURL = self.frontImageURL, let backImageURL = self.backImageURL, let frontAnalysis = self.frontAnalysis, let backAnalysis = self.backAnalysis else {
            print("Scan Fields Are Missing")
            return
        }
        
        
        //now that we have the images and analysis, store as a scan in scan collection with the user's UID (so we have to reference AuthViewModel asweell)
        let scan = ScanObject(createdAt: Date(), userUID: self.uid, frontImage: frontImageURL, backImage: backImageURL, frontAnalysis: frontAnalysis, backAnalysis: backAnalysis)
        
        
        //does NOT WORK because of app check
        do {
            try db.collection("scans").addDocument(from: scan)
        } catch let error {
            print("Error writing city to Firestore: \(error)")
            }
    
    
        
        //store all data in Scan Struct then add to firebase
        
        
    }
    
    func convertImageToBase64(img: UIImage) -> String {
        return img.jpegData(compressionQuality: 1)!.base64EncodedString()
    }
    func convertImagePNGData(img: UIImage) -> Data {
        return img.pngData()!
    }
    //Firebase STORAGE///
    
    //when we save scan, we save the images and pass it to here to receive back a URL that points back to it
    func uploadFile(data: Data, path: String) async throws -> URL {
        return try await withCheckedThrowingContinuation { continuation in
            let storage = Storage.storage()
            let storageRef = storage.reference().child(path)
            
            storageRef.putData(data, metadata: nil) { metadata, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                storageRef.downloadURL { url, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                    } else if let url = url {
                        continuation.resume(returning: url)
                    } else {
                        continuation.resume(throwing: NSError(domain: "UnexpectedError", code: -1, userInfo: nil))
                    }
                }
            }
        }
    }
    
    
    //CLOUD FUNCTIONS //
    
    
    // make separate analysis function for front and back analysis

    func createFrontAnalysis(img: UIImage) async throws {
        let base64 = self.convertImageToBase64(img: img)
        
        //let data: [String: Any] = ["base64": base64] // Your arguments
        Functions.functions().useEmulator(withHost: "http://10.0.0.101", port: 5001)
 
        let response: String = try await withCheckedThrowingContinuation { continuation in
                functions.httpsCallable("returnFrontAnalysis").call(base64) { result, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                    } else if let data = result?.data as? String {
                        continuation.resume(returning: data)
                    } else {
                        continuation.resume(throwing: NSError(domain: "UnexpectedError", code: -1, userInfo: nil))
                    }
                }
            }
            
            // Decode the JSON response
            do {
                self.frontAnalysisJSON = response.data(using: .utf8)
                let decoder = JSONDecoder()
                self.frontAnalysis = try decoder.decode(FrontAnalysis.self, from: frontAnalysisJSON!)
            } catch {
                print("Error decoding JSON: \(error)")
                throw error
            }
        
        //Need to wrap cloud function in await or else this will run before we get result
        print("Called front Analysis")

    }
    

    func createBackAnalysis(img: UIImage) async throws {
        let base64 = self.convertImageToBase64(img: img)
        
        //let data: [String: Any] = ["base64": base64] // Your arguments
        Functions.functions().useEmulator(withHost: "http://10.0.0.101", port: 5001)
 
        let response: String = try await withCheckedThrowingContinuation { continuation in
                functions.httpsCallable("returnBackAnalysis").call(base64) { result, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                    } else if let data = result?.data as? String {
                        continuation.resume(returning: data)
                    } else {
                        continuation.resume(throwing: NSError(domain: "UnexpectedError", code: -1, userInfo: nil))
                    }
                }
            }
            
            // Decode the JSON response
            do {
                self.backAnalysisJSON = response.data(using: .utf8)
                let decoder = JSONDecoder()
                self.backAnalysis = try decoder.decode(BackAnalysis.self, from: backAnalysisJSON!)
            } catch {
                print("Error decoding JSON: \(error)")
                throw error
            }
  
    }

    
    func fetchScanObjects() async throws -> [ScanObject] {
        return try await withCheckedThrowingContinuation { continuation in
            db.collection("scans")
                .whereField("userUID", isEqualTo: self.uid as Any)
                .getDocuments { snapshot, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                    } else if let snapshot = snapshot {
                        let fetchedScans: [ScanObject] = snapshot.documents.compactMap { doc in
                            try? doc.data(as: ScanObject.self) // Decode Firestore documents into `ScanObject`
                        }
                        continuation.resume(returning: fetchedScans)
                    } else {
                        continuation.resume(returning: [])
                    }
                }
        }
    }

    func loadImage(from urlString: String) async throws -> UIImage {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        guard let image = UIImage(data: data) else {
            throw NSError(domain: "ImageErrorDomain", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to decode image"])
        }
        print("return image")
        return image
    }
    
    
    
    
    
}
