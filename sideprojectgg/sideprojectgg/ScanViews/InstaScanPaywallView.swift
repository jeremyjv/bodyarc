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
    
    let generator = UIImpactFeedbackGenerator(style: .heavy)

    var body: some View {
        ZStack {
            
            VStack {
                LinearGradient(
                        gradient: Gradient(colors: [
                            Color.blue.opacity(0.2), // Start with a yellowish hue
                            Color.clear,               // Fade to transparent
                            Color.black
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: UIScreen.main.bounds.height * 0.5) // Top 30% of the screen
                Spacer()
            }
            .edgesIgnoringSafeArea(.top)
            // Main Paywall Content
            VStack(spacing: 30) {
                
                Text("Insta Scan")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Spacer()
                
                ZStack {
                    // Black background for ratings
                    Rectangle()
                        .fill(Color(red: 0.05, green: 0.05, blue: 0.05))
                        .cornerRadius(20)
                        .frame(width: 320, height: 250) // Adjust height as needed
                    
        
                    
                    // Ratings
                    VStack(spacing: 5) {
                        HStack(spacing: 35) {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("V-Taper")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                RoundedBlurView()
                         
                                ProgressBar(score: 87)
                            }
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Leanness")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                RoundedBlurView()
    
                                ProgressBar(score: 95)
                            }
                        }
                        HStack(spacing: 35) {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Shoulders")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                RoundedBlurView()
                                ProgressBar(score: 75)
                            }
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Chest")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                RoundedBlurView()
                                ProgressBar(score: 55)
                            }
                        }
                        HStack(spacing: 35) {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Arms")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                RoundedBlurView()
                                ProgressBar(score: 66)
                            }
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Abs")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                RoundedBlurView()
                                ProgressBar(score: 60)
                            }
                        }
            
                    }
                    .padding()
              
                }
                Spacer()
                
                Text("We have a small fee because our AI scans are expensive for us, thank you for understanding 🫡")
                    .font(.body)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center) // Centers the text across multiple lines
                
                Button(action: {
                    generator.impactOccurred()
                    isProcessing = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        showDotsAnimation = true
                    }
                    handlePurchase()
                }) {
                    Text("Get Ratings Now")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity, minHeight: 70) // Set minimum height
                        .background(Color(red: 0.0627, green: 0.4745, blue: 0.6980))
                        .cornerRadius(35)
                }
            }
            .padding()

            // Loading Overlay
            if isProcessing {
                Color.black.opacity(0.5) // Dim background
                    .edgesIgnoringSafeArea(.all)
                
                

                VStack(spacing: 20) {
                    
                    Spacer() 
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
                    
                    Spacer()
                    Spacer()
                        
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
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    path.removeLast()
                    generator.impactOccurred()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.gray) // Set the color to gray
                    }
                }
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
                        path.append("FrontInstructionsView")

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
