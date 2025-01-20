//
//  InstaScanPaywallView.swift
//  sideprojectgg
//
//  Created by Jeremy Villanueva on 1/19/25.
//

import SwiftUI
import RevenueCat
import RevenueCatUI

struct InstaScanPaywallView: View {
    
    //this code snippet is when the user wants to InstaScan -> update userTable to have active scan
    

    
    //Business logic for this is: if it is successful we add 1 to their instascan then decrement their instascan when they scan
    
    var body: some View {
        Text("InstaScan paywall here")
        Button(action: {
            //put BodyArcOneOff Package Here
            
            //obtain InstaScanPackage
            Purchases.shared.getOfferings { (offerings, error) in
                if let instaScan = offerings?["InstaScan"] {
                    let packages = instaScan.availablePackages
                    // `packages` should contain each coin package with an identifier like 'coins-100'
                    
                    //obtain first package
                    Purchases.shared.purchase(package: packages[0]) { transaction, customerInfo, error, userCancelled in
                        if let customerInfo = customerInfo, error == nil {
                            // Increment user's instaScans by 1 here
                        } else if let error = error {
                            // Handle the error
                            print("Purchase failed: \(error.localizedDescription)")
                        } else if userCancelled {
                            print("User cancelled the purchase.")
                        }
                    }
                }
            }
            
            
           
        }) {
            Text("Purchase instascan")
        }
    }
}

#Preview {
    InstaScanPaywallView()
}
