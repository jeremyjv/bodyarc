//
//  ReferralView.swift
//  sideprojectgg
//
//  Created by Jeremy Villanueva on 1/21/25.
//

import SwiftUI
import FirebaseFirestore
import UIKit

struct RedeemReferralView: View {
    //eventually add loading while we check referral
    @EnvironmentObject var viewModel: ContentViewModel
    @Binding var path: NavigationPath
    
    var body: some View {
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
                
            }
        }) {
            Text("Your Referral Code: \(viewModel.user!.referralCode!)")
            Text("copy to clipboard")
        }
        
        
        
        

    }
    
    //create function to redeem referral
    private func fetchUserReferrals() {
        // Reference to the Firestore database
        let db = Firestore.firestore()
        
        // Assuming the user's document ID or user ID is available
        guard let userId = viewModel.uid else {
            print("Error: User ID not available.")
            return
        }
        
        // Reference to the user's document
        let userRef = db.collection("users").document(userId)
        
        // Perform a transaction to check and update the referral amount
        db.runTransaction { (transaction, errorPointer) -> Any? in
            // Fetch the current user document
            let userDocument: DocumentSnapshot
            do {
                userDocument = try transaction.getDocument(userRef)
            } catch let fetchError {
                print("Error fetching user document: \(fetchError)")
                errorPointer?.pointee = fetchError as NSError
                return nil
            }
            
            // Check if the referralAmount exists and is valid
            guard let referralAmount = userDocument.data()?["referralAmount"] as? Int else {
                print("referralAmount field is missing or invalid.")
                return nil
            }
            
            // If referralAmount is 3 or greater, decrement by 3
            if referralAmount >= 3 {
                transaction.updateData(["referralAmount": referralAmount - 3], forDocument: userRef)
                return true // Indicate success
            } else {
                return false // Indicate no update
            }
        } completion: { (object, error) in
            if let error = error {
                print("Transaction failed: \(error)")
            } else if let success = object as? Bool {
                if success {
                    print("Referral amount redeemed successfully.")
                    self.handleReferralRedemption() // Add your redemption logic here
                } else {
                    print("Referral amount is less than 3. No changes made.")
                }
            }
        }
    }
    
    // Function to handle the redemption logic
    private func handleReferralRedemption() {
        //run scan business logic here
        
        Task {
            await viewModel.handleScanUploadAction()
        }
        
        DispatchQueue.main.async {
            //redirect
            path = NavigationPath()
            viewModel.selectedTab = "ProgressView"
            //redirect
        }

        
    }
}


