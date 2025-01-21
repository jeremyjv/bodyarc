//
//  PaywallView.swift
//  sideprojectgg
//
//  Created by Jeremy Villanueva on 1/18/25.
//

import SwiftUI
import RevenueCat
import FirebaseFirestore

struct PaywallView: View {
    
    @EnvironmentObject var viewModel: ContentViewModel
    @Binding var path: NavigationPath
    
    
    var body: some View {
        Text("Unlock your ratings")
        Button(action: {
            //put BodyArcOneOff Package Here
            
            //update local data with dispatch here
            
            //obtain InstaScanPackage
            Purchases.shared.getOfferings { (offerings, error) in
                if let instaScan = offerings?["BodyArcGoldA"] {
                    let packages = instaScan.availablePackages
                    // `packages` should contain each coin package with an identifier like 'coins-100'
                    
                    //obtain first package
                    Purchases.shared.purchase(package: packages[0]) { transaction, customerInfo, error, userCancelled in
                        if let _ = customerInfo, error == nil {
                            //handle after payment scan logic here
                            DispatchQueue.main.async {
                                viewModel.isGold = true
                                viewModel.user!.lastGoldScan = Date()
                                setLastGoldScan()
                                path = NavigationPath()
                            }
                        
                            //redirect to Progress View
                            Task {
                                
                                await viewModel.handleScanUploadAction()
                            }
                            //close paywall and redirect to progress view
                       
                
                        }
                    }
                }
            }
        }) {
            Text("Unlock your ratings")
        }
        
        Spacer()
        Text("Get Body Arc Gold 🥇")
        Text("Invite 3 Friends")
        
    }
    
    func setLastGoldScan() {
        Task.detached {
            let db = Firestore.firestore()
            let userRef = await db.collection("users").document(viewModel.uid!)
            
            do {
                
                try await userRef.updateData([
                    "lastGoldScan": Date()
                ])
                await MainActor.run {
                    print("Last Gold Scan updated")
                }
            } catch {
                await MainActor.run {
                    print("Failed to update last gold scan: \(error.localizedDescription)")
                }
            }
        }
    }
}

#Preview {

}
