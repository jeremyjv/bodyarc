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
    
    @Published var muscleRankings: [String]? = []
    
    private var authStateListenerHandle: AuthStateDidChangeListenerHandle?
    
    @Published var scans: [ScanObject] = []
    @Published var retrievedScanImages: [[UIImage?]] = []
    
 
    
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
    func checkIfUserExists(uid: String) async throws -> Bool {
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(uid)
        
        let document = try await docRef.getDocument()
        return document.exists
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
            
            let userInFireStore = try await checkIfUserExists(uid: firebaseUser.uid)
            
            if userInFireStore == false {
                let userModel = User(email: firebaseUser.email, uid: firebaseUser.uid, intake: intakeForm)
            
                do {
                    try db.collection("users").document(firebaseUser.uid).setData(from: userModel)
                    print("added user \(firebaseUser.uid) to firestore")
                } catch let error {
                    print("Error writing user to Firestore: \(error)")
                    }
                
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

        // Placeholder scan object with empty fields
        let placeholderScan = ScanObject(
            createdAt: Date(),
            userUID: self.uid,
            frontImage: nil,
            backImage: nil,
            frontAnalysis: nil,
            backAnalysis: nil,
            muscleRanking: nil
        )

        // Notify ProgressView of a new scan in progress
        DispatchQueue.main.async {
            self.scans.insert(placeholderScan, at: 0) // Insert at the top
            self.retrievedScanImages.insert([nil, nil], at: 0) // Placeholder images
        }

        do {
            // Compute front and back analysis
            try await self.createFrontAnalysis(img: frontImage)
            try await self.createBackAnalysis(img: backImage)

            guard let frontAnalysis = self.frontAnalysis, let backAnalysis = self.backAnalysis else {
                print("Analysis fields are missing")
                return
            }

            // Compute muscle ranking
            let muscleRanking = self.rankMuscles(frontAnalysis: frontAnalysis, backAnalysis: backAnalysis)

            // Convert and upload images
            let frontImageData = self.convertToJPEGData(image: frontImage)
            let uuid1 = NSUUID().uuidString
            self.frontImageURL = try await self.uploadFile(data: frontImageData!, path: "/images/\(uuid1).png").absoluteString

            let backImageData = self.convertToJPEGData(image: backImage)
            let uuid2 = NSUUID().uuidString
            self.backImageURL = try await self.uploadFile(data: backImageData!, path: "/images/\(uuid2).png").absoluteString

            guard let frontImageURL = self.frontImageURL, let backImageURL = self.backImageURL else {
                print("Image URLs are missing")
                return
            }

            // Create the actual scan object
            let scan = ScanObject(
                createdAt: Date(),
                userUID: self.uid,
                frontImage: frontImageURL,
                backImage: backImageURL,
                frontAnalysis: frontAnalysis,
                backAnalysis: backAnalysis,
                muscleRanking: muscleRanking
            )

            // Write muscleRanking to User Firestore
            DispatchQueue.main.async {
                let db = Firestore.firestore()
                let data: [String: Any] = ["muscleRanking": muscleRanking]

                db.collection("users").document(self.uid!).updateData(data) { error in
                    if let error = error {
                        print("Error updating document: \(error.localizedDescription)")
                    } else {
                        print("Document successfully updated!")
                    }
                }
            }

            // Write scan object to Firestore
            let db = Firestore.firestore()
            try db.collection("scans").addDocument(from: scan)

            // Update the placeholder scan with actual data in ProgressView
            DispatchQueue.main.async {
                self.scans[0] = scan // Replace placeholder scan
                self.retrievedScanImages[0] = [
                    UIImage(data: frontImageData!), // Replace with actual front image
                    UIImage(data: backImageData!)  // Replace with actual back image
                ]
            }
        } catch let error {
            print("Error to Firestore: \(error)")

            // Handle failure case by removing the placeholder scan
            DispatchQueue.main.async {
                self.scans.remove(at: 0)
                self.retrievedScanImages.remove(at: 0)
            }
        }
    }
    
    
    
    func rankMuscles(frontAnalysis: FrontAnalysis, backAnalysis: BackAnalysis?) -> [String] {
        // Create a dictionary to hold the muscle rankings
        var muscleRankings: [String: Int] = [
            "Shoulders": frontAnalysis.shoulders,
            "Chest": frontAnalysis.chest,
            "Arms": frontAnalysis.arms,
            "Abs": frontAnalysis.abs
        ]
        
        // If BackAnalysis is provided, add the corresponding muscle groups to the dictionary
        if let back = backAnalysis {
            muscleRankings["Traps"] = back.traps
            muscleRankings["Lats"] = back.lats
            muscleRankings["Lower Back"] = back.lowerBack
        }
        
        // Sort the muscles by their ranking values
        let sortedMuscles = muscleRankings.sorted { $0.value < $1.value }.map { $0.key }
        
        return sortedMuscles
    }
    
    
    
    func convertImageToBase64(img: UIImage) -> String {
        return img.jpegData(compressionQuality: 1)!.base64EncodedString()
    }
    
    func convertToJPEGData(image: UIImage) -> Data? {
        let maxSizeInBytes = 3 * 1024 * 1024
        var compression: CGFloat = 1.0 // Start with the highest quality
        let minCompression: CGFloat = 0.1 // Minimum compression quality
        let step: CGFloat = 0.1 // Compression decrement step

        // Try to generate initial JPEG data
        guard let initialData = image.jpegData(compressionQuality: compression) else {
            return nil // Return nil if image conversion fails
        }

        // Check if the initial data size is already below the max size
        if initialData.count <= maxSizeInBytes {
            return initialData
        }

        // Reduce the compression quality iteratively
        var currentData = initialData
        while currentData.count > maxSizeInBytes && compression > minCompression {
            compression -= step
            if let newData = image.jpegData(compressionQuality: compression) {
                currentData = newData
            } else {
                break
            }
        }

        // Ensure the final data size is within limits
        return currentData.count <= maxSizeInBytes ? currentData : nil
    }
    //Firebase STORAGE///
    
    //when we save scan, we save the images and pass it to here to receive back a URL that points back to it
    func uploadFile(data: Data, path: String) async throws -> URL {
        return try await withCheckedThrowingContinuation { continuation in
            let storage = Storage.storage()
            let storageRef = storage.reference().child(path)
            
            //puts it in image
            
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
        Functions.functions().useEmulator(withHost: "http://127.0.0.1", port: 5001)
 
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
        Functions.functions().useEmulator(withHost: "http://127.0.0.1", port: 5001)
 
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


    func loadImage(from path: String, maxSize: Int64 = 15 * 1024 * 1024) async throws -> UIImage {
        let storageRef = Storage.storage().reference(forURL: path)

            return try await withCheckedThrowingContinuation { continuation in
                storageRef.getData(maxSize: maxSize) { data, error in
                    if let error = error {
                        continuation.resume(throwing: error)  // Return error
                    } else if let data = data, let uiImage = UIImage(data: data) {
                        continuation.resume(returning: uiImage)  // Return UIImage
                    } else {
                        let decodeError = NSError(
                            domain: "ImageErrorDomain",
                            code: 0,
                            userInfo: [NSLocalizedDescriptionKey: "Failed to decode image data."]
                        )
                        continuation.resume(throwing: decodeError)  // Return decoding error
                    }
                }
            }
        }
    
    
    
    
    
}
