//
//  ScanEdgeView.swift
//  sideprojectgg
//
//  Created by Jeremy Villanueva on 1/19/25.
//

import SwiftUI
import RevenueCat
import RevenueCatUI

//need to mount front image to this view
struct ScanEdgeView: View {
    
    @EnvironmentObject var viewModel: ContentViewModel
    @Binding var path: NavigationPath
    @State var showPaywall: Bool = false
    @State var showReferral: Bool = false
    var body: some View {
        
  
        
        
        Button(action: {
                    // Add your button action here
            showPaywall = true
        }) {
            Text("🥇 Get Body Arc Gold")
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(red: 0.0627, green: 0.4745, blue: 0.6980))
                .cornerRadius(25)
        }
        .padding()
        .fullScreenCover(isPresented: $showPaywall) {
            PaywallView(path: $path)
         
            //want to run handleScanUpload and lastGoldScan on a successfull purchase from the paywall footer
        }
        
    
        
        Button(action: {
            showReferral = true
        }) {
            
            Text("Invite 3 Friends")
        }
        .sheet(isPresented: $showReferral) {
            RedeemReferralView(path: $path)
            //want to run handleScanUpload and lastGoldScan on a successfull purchase from the paywall footer
        }
        

    }
}

#Preview {
    
}
