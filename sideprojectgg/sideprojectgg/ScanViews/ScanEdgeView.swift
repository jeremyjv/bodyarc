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
    
    @State var offering: Offering?
    
    
    let generator = UIImpactFeedbackGenerator(style: .heavy)
    
    

    var body: some View {
        ZStack {
            
            Color(red: 15/255, green: 15/255, blue: 15/255)
            .edgesIgnoringSafeArea(.all) // Ensures it covers the entire screen
            
            VStack {
                LinearGradient(
                        gradient: Gradient(colors: [
                            Color.blue.opacity(0.2), // Start with a yellowish hue
                            Color.clear,               // Fade to transparent
                            Color(red: 15/255, green: 15/255, blue: 15/255)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: UIScreen.main.bounds.height * 0.5) // Top 30% of the screen
                Spacer()
            }
            .edgesIgnoringSafeArea(.top)
            
            // Main Content
            
            
            VStack(spacing: 15) {
                Text("👀Unlock your ratings")
                    .font(.largeTitle)
                    .padding(.horizontal)
                Text("Invite 3 friends or get BodyArc Gold to see your ratings")
                    .font(.body) // Small font size
                    .foregroundColor(.white.opacity(0.7)) // Faint white text
                    .multilineTextAlignment(.center) // Centers text within its own frame
                    .padding(.horizontal)
                //add blurred ratings
                Spacer()
                ZStack {
                    // Black background for ratings
                    Rectangle()
                        .fill(Color(red: 0.05, green: 0.05, blue: 0.05))
                        .cornerRadius(20)
                        .frame(width: 320, height: 300) // Adjust height as needed
                    
                   
                    Image(uiImage: viewModel.frontImage!)
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(20)
                        .frame(width: 250, height: 250) // Adjust dimensions as needed
                        .offset(y: -210)
                    
                    
                    // Ratings
                    VStack(spacing: 5) {
                        HStack(spacing: 35) {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("V-Taper")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                RoundedBlurView()
                         
                                ProgressBar(score: 0)
                            }
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Leanness")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                RoundedBlurView()
    
                                ProgressBar(score: 0)
                            }
                        }
                        HStack(spacing: 35) {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Shoulders")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                RoundedBlurView()
                                ProgressBar(score: 0)
                            }
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Chest")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                RoundedBlurView()
                                ProgressBar(score: 0)
                            }
                        }
                        HStack(spacing: 35) {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Arms")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                RoundedBlurView()
                                ProgressBar(score: 0)
                            }
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Abs")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                RoundedBlurView()
                                ProgressBar(score: 0)
                            }
                        }
                
            
                    }
                    .padding()
                    .offset(y: 20)
                }
                
                Button(action: {
                    generator.impactOccurred()
                    showPaywall = true
                }) {
                    Text("🥇Get BodyArc Gold")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity, minHeight: 70) // Set minimum height
                        .background(Color(red: 0.0627, green: 0.4745, blue: 0.6980))
                        .cornerRadius(35)
                }
                .padding(.horizontal)
                .fullScreenCover(isPresented: $showPaywall) {
                    NavigationStack {
                        PaywallView()
                            .paywallFooter(condensed: true)
                            .onPurchaseCompleted({ customerInfo in
                                
                                print(customerInfo)
                                
                                //handle after payment scan logic here
                                DispatchQueue.main.async {
                                    viewModel.isGold = true
                                    viewModel.user!.lastGoldScan = Date()
                                    setLastGoldScan()
                                    path = NavigationPath()
                                    viewModel.selectedTab = "ProgressView"
                                }
                                
                                //redirect to Progress View
                                Task {
                                    await viewModel.handleScanUploadAction()
                                }
                            })
                            .toolbar {
                                ToolbarItem(placement: .navigationBarLeading) {
                                    Button(action: {
                                        showPaywall = false
                                    }) {
                                        HStack {
                                            Image(systemName: "xmark")
                                                .foregroundColor(.gray)
                                                .padding()
                                        }
                                        .padding(.top)
                                    }
                                }
                            }
                    }
                            
                }
                
                
                Button(action: {
                    generator.impactOccurred()
                    showReferral = true
                }) {
                    Text("Invite 3 Friends")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity, minHeight: 70) // Set minimum height
                        .background(Color.black)
                        .cornerRadius(35)
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
        .navigationBarBackButtonHidden(true) // Back button removed
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


struct RoundedBlurView: View {
    var cornerRadius: CGFloat = 16
    var height: CGFloat = 25
    var shadowRadius: CGFloat = 15 // Increased shadow radius for more drama

    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(
                RadialGradient(
                    gradient: Gradient(colors: [
                        Color.white.opacity(0.7), // Brighter center
                        Color.black.opacity(0.0)
                    ]),
                    center: .center,
                    startRadius: 1,
                    endRadius: 100 // Reduced radius for a tighter, more dramatic glow
                )
            )
            .frame(width: 50, height: height) // Adjusted width for better visibility
            .shadow(color: Color.white.opacity(0.5), radius: shadowRadius, x: 0, y: 5) // Stronger shadow
    }
}

struct BlurredProgressBar: View {
    var score: Int

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Background bar
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 12) // Adjust height here

                // Foreground bar
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(red: 215/255, green: 215/255, blue: 215/255))
                    .frame(width: CGFloat(score) / 100.0 * geometry.size.width, height: 12) // Adjust height here
            }
        }
        .frame(width: 120, height: 12) // Set the width to a shorter value (e.g., 100) // Set the fixed height of the ProgressBar
    }


}
