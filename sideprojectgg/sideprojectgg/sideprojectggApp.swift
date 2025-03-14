//
//  sideprojectggApp.swift
//  sideprojectgg
//
//  Created by Jeremy Villanueva on 12/2/24.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseAuth
import GoogleSignIn
import FirebaseFirestore
import RevenueCat
import RevenueCatUI


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()


    return true
  }
    

}

@main
struct sideprojectggApp: App {
  // register app delegate for Firebase setup
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    //now we can access from any view under ContentView and update info in respective pages
    init() {
        
        Purchases.configure(withAPIKey: "appl_QHxSKCyTmIlFUuTfLecrfUoEvtu")
    }
    
    @StateObject private var viewModel = ContentViewModel()
    
    //find all references to authViewModel then reference to viewModel instead
  

  var body: some Scene {
    WindowGroup {
        ZStack {
            Color(red: 26/255, green: 26/255, blue: 26/255)
            .edgesIgnoringSafeArea(.all) // Ensures it covers the entire screen
            
            ContentView()
              .environmentObject(viewModel)
        
              
              
            
        }
      
            
              
    }
  }
}
