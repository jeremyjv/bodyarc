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
    

    
    @State var isGold: Bool?

    

    var body: some View {
        

        VStack(spacing: 10) {
            
            if loading {
                Text("Loading Data")
            } else {
                Button(action: {
                    viewModel.signOut()
                }) {
                    Text("sign out")
                }
                
                Button(action: {
                    path.append("InstaScanPaywallView")
                }) {
                    Text("InstaScan")
                }
                
                
                
                ZStack {
                    Image(uiImage: UIImage(named: "scanImage")!)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 320, height: 423)
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
                       Calendar.current.date(byAdding: .day, value: -7, to: Date())! < lastGoldScan && isGold! {
                        //if user is not a gold member // never display this
                    
                        CustomScanButton(title: "InstaScan", path: $path, dest: "InstaScanPaywallView")
                    } else {
                        
                        CustomScanButton(title: "Begin Scan", path: $path, dest: "FrontScanView")
                            .offset(y: 200)
                    }
                    
                }
            }
            
        }
        .onAppear(perform: fetchUserData) // Fetch user data when view appears
        .onAppear {
            Task {
                let customerInfo = try await Purchases.shared.customerInfo()
                self.isGold = customerInfo.entitlements["MonthlyPremiumA"]?.isActive == true
            }
        }
    
        
    }
 
    
    // Fetch user data from Firestore
    func fetchUserData() {
        let db = Firestore.firestore()
        guard let uid = viewModel.uid else { return }
        let userRef = db.collection("users").document(uid)
        
        userRef.getDocument { snapshot, error in
            if let error = error {
                print("Error fetching user: \(error.localizedDescription)")
                loading = false
                return
            }
            
            do {
                if let snapshot = snapshot {
                    // Decode Firestore data directly into the User model
                    viewModel.user = try snapshot.data(as: User.self)
                    print("User fetched successfully: \(String(describing: viewModel.user))")
                } else {
                    print("User document does not exist.")
                }
            } catch {
                print("Error decoding user data: \(error.localizedDescription)")
            }
            
            loading = false
        }
    }
    
    // Logic to determine if the InstaScan button should be shown
    private func shouldShowInstaScanButton(lastScanDate: Date?) -> Bool {
        guard let lastScan = lastScanDate else { return false } // don't show if no scan date exists
        let sevenDaysAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
        return lastScan < sevenDaysAgo
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
            .frame(maxWidth: 300, maxHeight: 80) // Set button dimensions
            .padding()
        }
    }
   
    
}


#Preview {
 
}
