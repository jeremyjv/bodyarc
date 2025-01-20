//
//  PaywallView.swift
//  sideprojectgg
//
//  Created by Jeremy Villanueva on 1/18/25.
//

import SwiftUI
import RevenueCat

struct PaywallView: View {
    var body: some View {
        Text("Unlock your ratings")
        Button(action: {
            //put BodyArcOneOff Package Here
            
            //obtain InstaScanPackage
            Purchases.shared.getOfferings { (offerings, error) in
                if let instaScan = offerings?["BodyArcGoldA"] {
                    let packages = instaScan.availablePackages
                    // `packages` should contain each coin package with an identifier like 'coins-100'
                    
                    //obtain first package
                    Purchases.shared.purchase(package: packages[0]) { transaction, customerInfo, error, userCancelled in
                        if let _ = customerInfo, error == nil {
                            //handle scan logic here
                            
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
}

#Preview {
    PaywallView()
}
