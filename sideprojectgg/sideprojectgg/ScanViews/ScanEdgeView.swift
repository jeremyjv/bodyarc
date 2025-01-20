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
    
    @State var showPaywall: Bool = false
    var body: some View {
        Button(action: {
            showPaywall = true
        }) {
            
            Text("🥇Get Body Arc Gold")
        }
        .sheet(isPresented: $showPaywall, content: {
            PaywallView()
                .paywallFooter(condensed: true)
        })
        Text("Invite 3 Friends")
        
        
        
        
        
        //Have a redirect to PaywallView
        
        //Have a popup sheet for referrals
    }
}

#Preview {
    ScanEdgeView()
}
