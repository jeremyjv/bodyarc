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
import RevenueCat
import AuthenticationServices
import CryptoKit
import JWTDecode
import FirebaseCore


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
    
    @Published var user: User?
    
    let db = Firestore.firestore()
    
    //Auth view model data
    
    @Published var email: String?
    @Published var uid: String?
    @Published var isLoggedIn = false
    
    @Published var muscleRankings: [String]? = []
    
    private var authStateListenerHandle: AuthStateDidChangeListenerHandle?
    
    @Published var scans: [ScanObject]? = []
    @Published var retrievedScanImages: [[UIImage?]] = []
    
    @Published var isScanProcessing: Bool = false
    
    @Published var isGold: Bool?
    
    @Published var selectedTab: String = "ScanView"
    
    @Published var subOffering: Offering?
    @Published var instaOffering: Offering?
    
    @Published var progressPhotos: [ProgressPhotos]? = nil
    @Published var retrievedProgressImages: [[UIImage?]] = []  // Add this line
 
    
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
                
                
                //if intake form has a referral code -> query firebase and add 1 to the user that owns that referral code
                if let referralCode = intakeForm.referralCode {
                    let db = Firestore.firestore()
                    
                    do {
                        // Query for all users with the given referral code
                        let querySnapshot = try await db.collection("users")
                            .whereField("referralCode", isEqualTo: referralCode)
                            .getDocuments()
                        
                        if querySnapshot.documents.isEmpty {
                            print("No users found with referralCode \(referralCode).")
                        } else {
                            // Iterate over all matching documents and update their referralAmount
                            for document in querySnapshot.documents {
                                let userID = document.documentID
                                
                                await MainActor.run {
                                    db.collection("users").document(userID).updateData([
                                        "referralAmount": FieldValue.increment(Int64(1))
                                    ]) { error in
                                        if let error = error {
                                            print("Error updating user \(userID): \(error.localizedDescription)")
                                        } else {
                                            print("Successfully incremented referral amount for user with ID: \(userID)")
                                        }
                                    }
                                }
                            }
                        }
                    } catch {
                        print("Error: \(error.localizedDescription)")
                    }
                }
                
                
                //logic for creating referral code
                let randomNumber = String(Int.random(in: 10...99))
                
                let uidString = "\(firebaseUser.uid)"
                
                let startIndex = uidString.index(uidString.startIndex, offsetBy: 0) // First character
                let middleIndex = uidString.index(uidString.startIndex, offsetBy: 3) // Up to the 4th character
                let endIndex = uidString.index(uidString.startIndex, offsetBy: 5)   // 6th character

                // Slice the string using indices
                let firstPart = uidString[startIndex..<middleIndex]
                let lastChar = uidString[endIndex]

                // Create the referral code
                let referralCode = "\(firstPart)\(randomNumber)\(lastChar)"
                
                //new user always starts with referralAmount == 0
                let userModel = User(email: firebaseUser.email, uid: firebaseUser.uid, intake: intakeForm, referralCode: referralCode, referralAmount: 0)
                
                //when another user uses their code we increase the referralAmount for the user with the corresponding referral code.
                
                //safeguard so only increase referralAmount when new user is created, use intake form to capture referral code -> or else they could just re-enter code everytime
                
                do {
                    
                    
                    try db.collection("users").document(firebaseUser.uid).setData(from: userModel)
                    print("added user \(firebaseUser.uid) to firestore")
                } catch let error {
                    print("Error writing user to Firestore: \(error)")
                    }
                
            }
            
            self.uid = firebaseUser.uid
            
            //want to redirect to GoalsView
            isLoggedIn = true
            
            print("User \(firebaseUser.uid) signed in with \(firebaseUser.email ?? "unknown")")
            
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
        
    }
    


    
    func signInWithApple(intakeForm: IntakeForm) async -> Bool {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first,
              let rootViewController = window.rootViewController else {
            print("There is no root view controller")
            return false
        }
        
        let delegate = SignInWithAppleDelegate()
        authorizationController.delegate = delegate
        authorizationController.presentationContextProvider = delegate
        
        do {
            let credential = try await delegate.performSignIn()
            
            guard let appleIDToken = credential.identityToken else {
                print("Apple ID Token is missing")
                return false
            }
            
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return false
            }
            
            let firebaseCredential = OAuthProvider.credential(providerID: AuthProviderID.apple, idToken: idTokenString, rawNonce: delegate.currentNonce!)
            
            let result = try await Auth.auth().signIn(with: firebaseCredential)
            let firebaseUser = result.user
            
            let db = Firestore.firestore()
            
            let userInFireStore = try await checkIfUserExists(uid: firebaseUser.uid)
            
            if userInFireStore == false {
                if let referralCode = intakeForm.referralCode {
                    do {
                        let querySnapshot = try await db.collection("users")
                            .whereField("referralCode", isEqualTo: referralCode)
                            .getDocuments()
                        
                        if querySnapshot.documents.isEmpty {
                            print("No users found with referralCode \(referralCode).")
                        } else {
                            for document in querySnapshot.documents {
                                let userID = document.documentID
                                
                                await MainActor.run {
                                    db.collection("users").document(userID).updateData([
                                        "referralAmount": FieldValue.increment(Int64(1))
                                    ]) { error in
                                        if let error = error {
                                            print("Error updating user \(userID): \(error.localizedDescription)")
                                        } else {
                                            print("Successfully incremented referral amount for user with ID: \(userID)")
                                        }
                                    }
                                }
                            }
                        }
                    } catch {
                        print("Error: \(error.localizedDescription)")
                    }
                }
                
                let randomNumber = String(Int.random(in: 10...99))
                let uidString = "\(firebaseUser.uid)"
                
                let startIndex = uidString.index(uidString.startIndex, offsetBy: 0)
                let middleIndex = uidString.index(uidString.startIndex, offsetBy: 3)
                let endIndex = uidString.index(uidString.startIndex, offsetBy: 5)
                
                let firstPart = uidString[startIndex..<middleIndex]
                let lastChar = uidString[endIndex]
                
                let referralCode = "\(firstPart)\(randomNumber)\(lastChar)"
                
                let userModel = User(email: firebaseUser.email, uid: firebaseUser.uid, intake: intakeForm, referralCode: referralCode, referralAmount: 0)
                
                do {
                    try db.collection("users").document(firebaseUser.uid).setData(from: userModel)
                    print("Added user \(firebaseUser.uid) to Firestore")
                } catch let error {
                    print("Error writing user to Firestore: \(error)")
                }
            }
            
            self.uid = firebaseUser.uid
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
        // Ensure front image is not nil
        guard let frontImage = self.frontImage else {
            print("Front image is missing")
            return
        }
        
        isScanProcessing = true // Set processing state
        
        do {
            // Compute front analysis
            try await self.createFrontAnalysis(img: frontImage)
            
            // Attempt back analysis only if the back image is provided
            if let backImage = self.backImage {
                try await self.createBackAnalysis(img: backImage)
            }

            let frontAnalysis = self.frontAnalysis
            let backAnalysis = self.backImage != nil ? self.backAnalysis : nil

            // Compute muscle ranking (handle case where back analysis is missing)
            let muscleRanking = self.rankMuscles(frontAnalysis: frontAnalysis!, backAnalysis: backAnalysis)

            // Convert and upload front image
            let frontImageData = self.convertToJPEGData(image: frontImage)
            let uuid1 = NSUUID().uuidString
            self.frontImageURL = try await self.uploadFile(data: frontImageData!, path: "/images/\(uuid1).png").absoluteString

            var backImageURL: String? = nil
            if let backImage = self.backImage {
                let backImageData = self.convertToJPEGData(image: backImage)
                let uuid2 = NSUUID().uuidString
                backImageURL = try await self.uploadFile(data: backImageData!, path: "/images/\(uuid2).png").absoluteString
            }

            guard let frontImageURL = self.frontImageURL else {
                print("Front image URL is missing")
                return
            }

            // Create the actual scan object
            let scan = ScanObject(
                createdAt: Date(),
                userUID: self.uid,
                frontImage: frontImageURL,
                backImage: backImageURL, // Can be nil
                frontAnalysis: frontAnalysis,
                backAnalysis: backAnalysis, // Can be nil
                muscleRanking: muscleRanking
            )
            
            // Update progress view with scan data
            DispatchQueue.main.async {
                self.scans!.insert(scan, at: 0) // Insert at the top
                self.retrievedScanImages.insert([frontImage] + (self.backImage != nil ? [self.backImage!] : []), at: 0)
                self.isScanProcessing = false // Reset processing state
            }

            // Write muscleRanking to Firestore
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

            // Update the scan object in ProgressView
            DispatchQueue.main.async {
                self.scans![0] = scan
                self.retrievedScanImages[0] = [
                    UIImage(data: frontImageData!)
                ] + (self.backImage != nil ? [UIImage(data: self.convertToJPEGData(image: self.backImage!)!)] : [])
            }
        } catch let error {
            print("Error processing scan: \(error)")
            DispatchQueue.main.async {
                self.scans!.remove(at: 0)
                self.retrievedScanImages.remove(at: 0)
                self.isScanProcessing = false // Reset processing state
            }
        }
    }
    
    func handleProgressLogic() async {
        guard let frontImage = self.frontImage else {
            print("Front image is missing")
            return
        }
        
        do {
            
            // Convert and upload front image
            let frontImageData = self.convertToJPEGData(image: frontImage)
            let uuid1 = NSUUID().uuidString
            self.frontImageURL = try await self.uploadFile(data: frontImageData!, path: "/progress_images/\(uuid1).png").absoluteString

            var backImageURL: String? = nil
            if let backImage = self.backImage {
                let backImageData = self.convertToJPEGData(image: backImage)
                let uuid2 = NSUUID().uuidString
                backImageURL = try await self.uploadFile(data: backImageData!, path: "/progress_images/\(uuid2).png").absoluteString
            }

            guard let frontImageURL = self.frontImageURL else {
                print("Front image URL is missing")
                return
            }

            // Create the progress photo object
            let newProgressPhoto = ProgressPhotos(
                userUID: self.uid,
                frontImage: frontImageURL,
                backImage: backImageURL,
                createdAt: Date()
            )
            
            // Write progress photo to Firestore
            let db = Firestore.firestore()
            try db.collection("progress").addDocument(from: newProgressPhoto)
            
            // Update the arrays with the new photo and images
            DispatchQueue.main.async {
                if self.progressPhotos == nil {
                    self.progressPhotos = []
                }
                self.progressPhotos?.insert(newProgressPhoto, at: 0)
                
                
                
                // Clear the temporary images
                self.frontImage = nil
                self.backImage = nil
                self.frontImageURL = nil
                self.backImageURL = nil
            }
            
        } catch {
            print("Error processing progress photos: \(error)")
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
        
        //enable emulator or not
        //Functions.functions().useEmulator(withHost: "http://127.0.0.1", port: 5001)
 
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
        
        //enable emulator or not
        //Functions.functions().useEmulator(withHost: "http://127.0.0.1", port: 5001)
 
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



class SignInWithAppleDelegate: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    var currentNonce: String?
    private var continuation: CheckedContinuation<ASAuthorizationAppleIDCredential, Error>?
    
    func performSignIn() async throws -> ASAuthorizationAppleIDCredential {
        return try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation
            
            let provider = ASAuthorizationAppleIDProvider()
            let request = provider.createRequest()
            request.requestedScopes = [.fullName, .email]
            
            let nonce = generateNonce()
            self.currentNonce = nonce
            request.nonce = sha256(nonce) // Hashing nonce before sending
            
            let controller = ASAuthorizationController(authorizationRequests: [request])
            controller.delegate = self
            controller.presentationContextProvider = self
            controller.performRequests()
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            continuation?.resume(returning: appleIDCredential)
            continuation = nil
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        continuation?.resume(throwing: error)
        continuation = nil
        print("Sign in with Apple error: \(error.localizedDescription)")
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        guard let window = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap({ $0.windows })
            .first(where: { $0.isKeyWindow }) else {
                fatalError("No valid window found")
        }
        return window
    }
    
    /// Generates a secure random nonce
    private func generateNonce(length: Int = 32) -> String {
        let charset: [Character] =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0..<16).map { _ in
                var random: UInt8 = 0
                _ = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
    
    /// Hashes the nonce using SHA256
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        return hashedData.compactMap { String(format: "%02x", $0) }.joined()
    }
}
