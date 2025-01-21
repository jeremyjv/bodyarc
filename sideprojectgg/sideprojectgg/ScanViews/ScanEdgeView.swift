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
    var body: some View {
        Button(action: {
            showPaywall = true
        }) {
            
            Text("🥇Get Body Arc Gold")
        }
        .fullScreenCover(isPresented: $showPaywall) {
            PaywallView(path: $path)
                .paywallFooter(condensed: true)
            //want to run handleScanUpload and lastGoldScan on a successfull purchase from the paywall footer
        }
        Text("Invite 3 Friends")
        

    }
}

#Preview {
    
}
