//
//  InstaScanPaywallView.swift
//  sideprojectgg
//
//  Created by Jeremy Villanueva on 1/19/25.
//

import SwiftUI
import RevenueCat
import RevenueCatUI
import Firebase

struct InstaScanPaywallView: View {
    @EnvironmentObject var viewModel: ContentViewModel
    @Binding var path: NavigationPath // Ensure you can modify the navigation stack
    
    @State private var isProcessing: Bool = false // Track if purchase is in progress
    
    var body: some View {
        ZStack {
            VStack {
                Text("InstaScan Paywall Here")
                
                Button(action: {
                
                    Purchases.shared.getOfferings { offerings, error in
                        guard let instaScan = offerings?["InstaScan"], error == nil else {
                            print("Failed to fetch offerings: \(error?.localizedDescription ?? "Unknown error")")
                          
                            return
                        }
                        
                        let packages = instaScan.availablePackages
                        Purchases.shared.purchase(package: packages[0]) { transaction, customerInfo, error, userCancelled in
                            isProcessing = true // Stop processing after purchase completes
                            
                            if let _ = customerInfo, error == nil {
                                // Update local state optimistically
                                isProcessing = false
                                // Navigate to FrontScanView
                                path = NavigationPath()
                                path.append("FrontScanView")
                                viewModel.user?.instaScans = 1
                                
                                // Update Firestore
                                let db = Firestore.firestore()
                                let userRef = db.collection("users").document(viewModel.uid!)
                                userRef.updateData([
                                    "instaScans": FieldValue.increment(Int64(1))
                                ]) { error in
                                    if let error = error {
                                        print("Failed to increment instaScans: \(error.localizedDescription)")
                                    } else {
                                        print("InstaScans incremented successfully!")
                                    }
                                }
                                
                                // Navigate to FrontScanView
                                
                            } else if let error = error {
                                print("Purchase failed: \(error.localizedDescription)")
                            } else if userCancelled {
                                print("User cancelled the purchase.")
                            }
                            isProcessing = false
                        }
                    }
                }) {
                    Text("Purchase InstaScan")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
            
            // Show a processing overlay when isProcessing is true
            if isProcessing {
                Color.black.opacity(0.5) // Dim background
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Text("Processing...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                        .background(Color.gray)
                        .cornerRadius(10)
                }
            }
        }
    }
}

#Preview {
   
}
