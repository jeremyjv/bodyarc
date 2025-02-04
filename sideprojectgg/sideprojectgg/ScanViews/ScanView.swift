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



struct RectangleComponent: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(Color.gray.opacity(0.3)) // Adjust color and opacity
    }
}




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
                        viewModel.signOut()
                    }) {
                        Image(systemName: "gear")
                            .resizable()                // Makes the icon resizable
                            .scaledToFit()              // Ensures it maintains aspect ratio
                            .frame(width: 30, height: 30) // Sets the size
                            .foregroundColor(.gray)     // Sets the color of the icon
                            .padding()
                    }
                }
                Spacer()
                
                
                if loading {
                    VStack {
                       Spacer() // Pushes text downward
                       Text("Loading...")
                           .foregroundColor(.white)
                           .font(.title2)
                           .bold()
                           .multilineTextAlignment(.center)
                       Spacer() // Pushes text upward
                   }
                   .frame(maxWidth: .infinity, minHeight: 400) // Ensures a minimum height for centering
                } else {
                    
                    
                    ZStack {
                        Image(uiImage: UIImage(named: "scanImage")!)
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: 330, maxHeight: 500)
                            .cornerRadius(30)
                            .overlay(
                                // Gradient overlay at the bottom
                                LinearGradient(
                                    gradient: Gradient(stops: [
                                        .init(color: Color.clear, location: 0.65), // Transition starts 70% down
                                        .init(color: Color.black, location: 0.85) // Fully black at the bottom
                                    ]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                                .cornerRadius(30)
                            )
                        
                        // if user's last scan less than 7 days ago, display instascan button
                        
                        
                        
                        if let user = viewModel.user,
                           let lastGoldScan = user.lastGoldScan,
                           let isGold = viewModel.isGold, // Safely unwrap `isGold`
                           Calendar.current.date(byAdding: .day, value: -7, to: Date())! < lastGoldScan && isGold {
                            //if user is not a gold member // never display this
                            
                            //only redirect to paywall if they don't have instascans
                            if let instascan = user.instaScans, instascan > 0 {
                                CustomScanButton(title: "Insta Scan Now", path: $path, dest: "FrontInstructionsView")
                                    .offset(y: 210)
                                
                            } else {
                                CustomScanButton(title: "Insta Scan Now", path: $path, dest: "InstaScanPaywallView")
                                    .offset(y: 210)
                            }
                            
                        } else {
                            
                            CustomScanButton(title: "Begin Scan", path: $path, dest: "FrontInstructionsView")
                                .offset(y: 210)
                        }
                        
                    }
                }
                Spacer()
                if nextScan != 0 {
                    Text("Next Scan in \(daysUntilSevenDaysAfter(from: viewModel.user?.lastGoldScan ?? Date())) days")
                        .fontWeight(.bold)
                }
                Spacer()
            }
            
            
        }
        .onAppear {
            if !loaded {
                Task {
                    await fetchUserDataAndConfigurePurchase()
                    
                    //only show this if user has a lastGoldScan
                    if let lastScan = viewModel.user!.lastGoldScan {
                        self.nextScan = daysUntilSevenDaysAfter(from: lastScan)
                    }
                    
                }
                
            }
        }
        .onChange(of: viewModel.uid) { _, _ in
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
        
        // Get the difference in days from today to the target date
        let daysRemaining = calendar.dateComponents([.day], from: Date(), to: targetDate).day ?? 0
        
        return max(daysRemaining, 0) // Ensure it doesn't return a negative value
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
                print("customer is gold", customerInfo!.entitlements["MonthlyPremiumA"]?.isActive == true)
                viewModel.isGold = customerInfo!.entitlements["MonthlyPremiumA"]?.isActive == true
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
            .frame(maxWidth: 330, maxHeight: 80) // Set button dimensions
            .padding()
        }
    }
   
    
}


#Preview {
 
}
