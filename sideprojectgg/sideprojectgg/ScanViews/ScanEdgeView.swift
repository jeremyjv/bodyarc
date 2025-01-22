//
//  ScanEdgeView.swift
//  sideprojectgg
//
//  Created by Jeremy Villanueva on 1/19/25.
//

import SwiftUI
import RevenueCat
import RevenueCatUI
import FirebaseFirestore
import UIKit

//need to mount front image to this view
struct ScanEdgeView: View {
    @EnvironmentObject var viewModel: ContentViewModel
    @Binding var path: NavigationPath
    @State var showPaywall: Bool = false
    @State var showReferral: Bool = false
    @State private var textToCopy = "Hello, this text is copied to the clipboard!"
    @State private var showPopup = false // Controls the visibility of the popup

    var body: some View {
        ZStack {
            // Main Content
            VStack(spacing: 10) {
                Button(action: {
                    showPaywall = true
                }) {
                    Text("🥇 Get Body Arc Gold")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(red: 0.0627, green: 0.4745, blue: 0.6980))
                        .cornerRadius(30)
                }
                .padding(.horizontal)
                .fullScreenCover(isPresented: $showPaywall) {
                    PaywallView(path: $path)
                }
                
                Button(action: {
                    showReferral = true
                }) {
                    Text("Invite 3 Friends")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.black)
                        .cornerRadius(30)
                }
                .padding(.horizontal)
                .sheet(isPresented: $showReferral) {
                    VStack {
                        Button(action: {
                            Task {
                                fetchUserReferrals()
                            }
                        }) {
                            Text("Redeem Referrals")
                        }
                        
                        Button(action: {
                            Task {
                                UIPasteboard.general.string = viewModel.user!.referralCode!
                                showPopup = true // Show the popup
                                
                                // Automatically dismiss the popup after 2 seconds
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    withAnimation {
                                        showPopup = false
                                    }
                                }
                            }
                        }) {
                            Text("Your Referral Code: \(viewModel.user!.referralCode!)")
                            Text("Copy to Clipboard")
                        }
                    }
                    .presentationDetents([.fraction(0.40)])
                    .presentationDragIndicator(.visible)
                }
            }
            
            // Popup View
            if showPopup {
                PopupView()
                    .transition(.move(edge: .top)) // Slide-in animation
                    .zIndex(1) // Ensure the popup is above other views
                    .frame(maxHeight: .infinity, alignment: .top) // Align to the top
            }
        }
        .animation(.easeInOut, value: showPopup)
    }

    // Popup View
    private func PopupView() -> some View {
        VStack {
            Text("Copied to Clipboard!")
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.green)
                .cornerRadius(10)
                .shadow(radius: 5)
        }
        .padding(.top, 15) // Space from the top
        .padding(.horizontal) // Add horizontal padding for better spacing
    }

    // Function to redeem referral
    private func fetchUserReferrals() {
        let db = Firestore.firestore()
        
        guard let userId = viewModel.uid else {
            print("Error: User ID not available.")
            return
        }
        
        let userRef = db.collection("users").document(userId)
        
        db.runTransaction { (transaction, errorPointer) -> Any? in
            let userDocument: DocumentSnapshot
            do {
                userDocument = try transaction.getDocument(userRef)
            } catch let fetchError {
                print("Error fetching user document: \(fetchError)")
                errorPointer?.pointee = fetchError as NSError
                return nil
            }
            
            guard let referralAmount = userDocument.data()?["referralAmount"] as? Int else {
                print("referralAmount field is missing or invalid.")
                return nil
            }
            
            if referralAmount >= 3 {
                transaction.updateData(["referralAmount": referralAmount - 3], forDocument: userRef)
                return true
            } else {
                return false
            }
        } completion: { (object, error) in
            if let error = error {
                print("Transaction failed: \(error)")
            } else if let success = object as? Bool, success {
                print("Referral amount redeemed successfully.")
                self.handleReferralRedemption()
            } else {
                print("Referral amount is less than 3. No changes made.")
            }
        }
    }

    private func handleReferralRedemption() {
        Task {
            await viewModel.handleScanUploadAction()
        }
        
        DispatchQueue.main.async {
            path = NavigationPath()
            viewModel.selectedTab = "ProgressView"
        }
    }
}
