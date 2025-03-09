//
//  ScanView.swift
//  sideprojectgg
//
//  Created by Jeremy Villanueva on 12/29/24.
//


import Foundation
import SwiftUI
import Firebase
import FirebaseFunctions
import PhotosUI
import FirebaseFirestore
import RevenueCat
import RevenueCatUI
import FirebaseAuth


struct ScanView: View {
    @EnvironmentObject var viewModel: ContentViewModel
    @Binding var path: NavigationPath
    
    @State private var defaultImage: UIImage?
    @State private var photosPickerItem: PhotosPickerItem?
    @State private var analysis: String?
    
    @State private var user: User? // User model to hold Firestore data
    @State private var loading = true // Loading state for Firestore fetch
    @State private var loaded = false
    @State private var nextScan = 0
    
    @State private var isSheetPresented = false
    

    
    @State var isGold: Bool?

    

    var body: some View {
        
        ZStack {
            Color(red: 15/255, green: 15/255, blue: 15/255)
            .edgesIgnoringSafeArea(.all) // Ensures it covers the entire screen
            VStack(spacing: 10) {
                        Spacer()
                        HStack {
                            Text("Physique Analysis")
                                .font(.title)
                                .foregroundColor(.white)
                                .lineLimit(1)
                                .bold()
                                .padding()
                            
                            Spacer()
                            
                            Button(action: {
                                isSheetPresented.toggle() // Open the settings sheet
                            }) {
                                Image(systemName: "gear")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(.gray)
                                    .padding()
                            }
                            .sheet(isPresented: $isSheetPresented) {
                                SettingsSheet(isPresented: $isSheetPresented)
                                    .presentationDetents([.fraction(0.50)])
                                    .presentationDragIndicator(.visible)
                            }
                        }
                        Spacer()
                        
                        if loading {
                            VStack {
                                Spacer()
                                Text("Loading...")
                                    .foregroundColor(.white)
                                    .font(.title2)
                                    .bold()
                                    .multilineTextAlignment(.center)
                                Spacer()
                            }
                            .frame(maxWidth: .infinity, minHeight: 400)
                        } else {
                            ZStack {
                                Image(uiImage: UIImage(named: "scanImage")!)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(minWidth: 320, maxWidth: 360)
                                    .cornerRadius(30)
                                    .overlay(
                                        LinearGradient(
                                            gradient: Gradient(stops: [
                                                .init(color: Color.clear, location: 0.65),
                                                .init(color: Color.black, location: 0.85)
                                            ]),
                                            startPoint: .top,
                                            endPoint: .bottom
                                        )
                                        .cornerRadius(30)
                                    )
                                    .padding()
                                
                                VStack {
                                  
                                   Spacer() // Pushes button to bottom
                                   
                                   if let user = viewModel.user,
                                      let lastGoldScan = user.lastGoldScan,
                                      let isGold = viewModel.isGold,
                                      Calendar.current.date(byAdding: .day, value: -7, to: Date())! < lastGoldScan && isGold {
                                       
                                       if let instascan = user.instaScans, instascan > 0 {
                                           CustomScanButton(title: "Insta Scan Now", path: $path, dest: "FrontInstructionsView")
                                       } else {
                                           CustomScanButton(title: "Insta Scan Now", path: $path, dest: "InstaScanPaywallView")
                                       }
                                   } else {
                                       CustomScanButton(title: "Begin Scan", path: $path, dest: "FrontInstructionsView")
                                   }
                               }
                               .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom) // Forces VStack to take full space and align button at bottom
                            }
                        }
                        Spacer()
                        if let lastScan = viewModel.user?.lastGoldScan {
                            if nextScan != 0 && isLessThanSevenDaysAgo(from: lastScan) {
                                Text("Next Scan in \(daysUntilSevenDaysAfter(from: lastScan)) days")
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            }
                        }
                        Spacer()
                    }
                }
        .onAppear {
            if !loaded {
                Task {
                    await fetchUserDataAndConfigurePurchase()
                    
                    //only show this if user has a lastGoldScan
                    if let lastScan = viewModel.user?.lastGoldScan {
                        self.nextScan = daysUntilSevenDaysAfter(from: lastScan)
                    }
                    
                }
                
            }
        }
        .onChange(of: viewModel.uid) { newUID in
            resetStates()
            Task {
                print("fetching new user")
                await fetchUserDataAndConfigurePurchase()
            }
        }
  
    
        
    }
    
    private func resetStates() {
            loading = true
            loaded = false
        }
    
    func daysUntilSevenDaysAfter(from date: Date) -> Int {
        let calendar = Calendar.current
        
        // Calculate the target date (7 days after the input date)
        guard let targetDate = calendar.date(byAdding: .day, value: 7, to: date) else {
            return 0 // Fallback in case of an error
        }
        
        // Get the difference in seconds and convert to days (rounding up)
        let timeInterval = targetDate.timeIntervalSinceNow
        let daysRemaining = Int(ceil(timeInterval / 86400)) // 86400 seconds in a day
        
        return max(daysRemaining, 0) // Ensure it doesn't return a negative value
    }
    
    func isLessThanSevenDaysAgo(from date: Date) -> Bool {
        let calendar = Calendar.current
        
        // Get the date 7 days ago from today
        guard let sevenDaysAgo = calendar.date(byAdding: .day, value: -7, to: Date()) else {
            return false
        }
        
        // Compare the input date with sevenDaysAgo
        return date > sevenDaysAgo
    }

    // Fetch user data from Firestore
    func fetchUserDataAndConfigurePurchase() async {
        let db = Firestore.firestore()
        
        guard let uid = viewModel.uid else { return }
        let userRef = db.collection("users").document(uid)
        

        do {
            // Step 1: Fetch Customer Info from RevenueCat
            // Configure Purchases with the custom App User ID
            Purchases.shared.logIn(uid) { (customerInfo, created, error) in
                print("customer is gold", customerInfo?.entitlements["MonthlyPremiumA"]?.isActive == true)
                viewModel.isGold = customerInfo?.entitlements["MonthlyPremiumA"]?.isActive == true
            }
            
     
            Purchases.shared.getOfferings { offerings, error in
                guard let offering = offerings?["BodyArcGoldA"], error == nil else {
                    print("Failed to fetch offerings: \(error?.localizedDescription ?? "Unknown error")")
             
                    return
                }
                
                viewModel.subOffering = offering
            }
            
            Purchases.shared.getOfferings { offerings, error in
                guard let offering = offerings?["InstaScan"], error == nil else {
                    print("Failed to fetch offerings: \(error?.localizedDescription ?? "Unknown error")")
             
                    return
                }
                
                viewModel.instaOffering = offering
            }
            
            
            // Step 2: Fetch User Data from Firestore
            let snapshot = try await userRef.getDocument()
            if let data = snapshot.data() {
                // Decode Firestore data into the User model
                let user = try Firestore.Decoder().decode(User.self, from: data)
                viewModel.user = user
            
              
                print("User fetched successfully: \(String(describing: viewModel.user))")
            } else {
                print("User document does not exist.")
            }
        } catch {
            print("Error: \(error.localizedDescription)")
        }
        
        // Step 3: Mark loading as complete
        loaded = true
        loading = false
        
    }
    
  
}

struct SettingsSheet: View {
    @EnvironmentObject var viewModel: ContentViewModel
    @Binding var isPresented: Bool
    let generator = UIImpactFeedbackGenerator(style: .heavy)
    
    // State variable to control the alert presentation
    @State private var showDeleteConfirmation = false

    var body: some View {
        ZStack {
            Color(red: 28/255, green: 28/255, blue: 30/255)
                .edgesIgnoringSafeArea(.all) // Ensures it covers the entire screen
            VStack(spacing: 20) {
                Text("Settings")
                    .font(.title)
                    .foregroundColor(.white)
                    .bold()
                    .padding(.top, 20)
                
            
                
                // Button to show delete confirmation
                Button(action: {
                    generator.impactOccurred()
                    showDeleteConfirmation = true // Show the confirmation alert
                }) {
                    Text("Delete Account")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal, 20)
                }
                .alert(isPresented: $showDeleteConfirmation) {
                    Alert(
                        title: Text("Confirm Deletion"),
                        message: Text("Are you sure you want to delete your account? This action cannot be undone."),
                        primaryButton: .destructive(Text("Delete")) {
                            deleteAccount() // Call the delete function if confirmed
                        },
                        secondaryButton: .cancel()
                    )
                }
                
                Spacer()
     
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    private func deleteAccount() {
        guard let user = Auth.auth().currentUser else {
            print("No authenticated user found.")
            return
        }
        
        viewModel.signOut()
        isPresented = false // Dismiss the sheet after signing out

        user.getIDToken { token, error in
            guard let token = token, error == nil else {
                print("Error getting ID token: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            let url = URL(string: "https://us-central1-sideprojectgg-80bce.cloudfunctions.net/deleteUserAccount")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error deleting user account: \(error.localizedDescription)")
                    return
                }

                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        print("User account deleted successfully")
                        DispatchQueue.main.async {
                            isPresented = false
                        }
                    } else {
                        print("Error: Server returned status code \(httpResponse.statusCode)")
                    }
                }

                if let data = data, let responseMessage = String(data: data, encoding: .utf8) {
                    print("Server Response: \(responseMessage)")
                }
            }.resume()
        }
    }
}

struct CustomScanButton: View {
    var title: String
    @Binding var path: NavigationPath
    var dest: String
    let generator = UIImpactFeedbackGenerator(style: .heavy)

    var body: some View {
        Button(action: {
            path.append(dest)
            generator.impactOccurred()
        }) {
            // Use a ZStack to ensure the entire area is tappable
            ZStack {
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 4 / 255, green: 96 / 255, blue: 255 / 255),
                        Color(red: 4 / 255, green: 180 / 255, blue: 255 / 255)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .cornerRadius(8)
                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)

                // Button text
                Text(title)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
            }
            .frame(minWidth: 320, maxWidth: 360, minHeight: 70, maxHeight: 80) // Set button dimensions
            .padding(.horizontal)
        }
    }
   
    
}


#Preview {
 
}
