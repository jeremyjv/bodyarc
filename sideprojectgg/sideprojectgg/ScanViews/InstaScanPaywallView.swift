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
    @Binding var path: NavigationPath

    @State private var isProcessing: Bool = false
    @State private var showDotsAnimation: Bool = false

    var body: some View {
        ZStack {
            // Main Paywall Content
            VStack {
                Text("InstaScan Paywall Here")
                    .font(.title)
                    .padding(.bottom, 20)

                Button(action: {
                    isProcessing = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        showDotsAnimation = true
                    }
                    handlePurchase()
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

            // Loading Overlay
            if isProcessing {
                Color.black.opacity(0.5) // Dim background
                    .edgesIgnoringSafeArea(.all)

                VStack(spacing: 20) {
                    Text("Processing...")
                        .font(.title)
                        .foregroundColor(.white)

                    // Dots animation
                    HStack(spacing: 10) {
                        ForEach(0..<5) { index in
                            Circle()
                                .frame(width: 10, height: 10)
                                .foregroundColor(.white)
                                .scaleEffect(showDotsAnimation ? 1.75 : 1)
                                .animation(
                                    Animation.easeInOut(duration: 0.6)
                                        .repeatForever()
                                        .delay(Double(index) * 0.2),
                                    value: showDotsAnimation
                                )
                        }
                    }
                }
            }
        }
        .onAppear {
            if isProcessing {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    showDotsAnimation = true
                }
            }
        }
        .onChange(of: isProcessing) { newValue, _ in
            if newValue {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    showDotsAnimation = true
                }
            } else {
                showDotsAnimation = false
            }
        }
    }

    private func handlePurchase() {
        DispatchQueue.main.async {
                
                let packages = viewModel.instaOffering!.availablePackages
                Purchases.shared.purchase(package: packages[0]) { transaction, customerInfo, error, userCancelled in
                    if let _ = customerInfo, error == nil {
                        isProcessing = false
                        viewModel.user?.instaScans = 1
                        path = NavigationPath()
                        path.append("FrontScanView")

                        // Update Firestore
                        let db = Firestore.firestore()
                        let userRef = db.collection("users").document(viewModel.uid!)
                        userRef.updateData([
                            "instaScans": Int64(1)
                        ]) { error in
                            if let error = error {
                                print("Failed to increment instaScans: \(error.localizedDescription)")
                            } else {
                                print("InstaScans incremented successfully!")
                            }
                        }
                    } else if let error = error {
                        print("Purchase failed: \(error.localizedDescription)")
                    } else if userCancelled {
                        print("User cancelled the purchase.")
                    }
                    isProcessing = false
                }
            
        }
    }
}

#Preview {
   
}
