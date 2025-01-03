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


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
  
      
    #if DEBUG
    // Connect to Firestore emulator in development
    let firestore = Firestore.firestore()
    let settings = firestore.settings
    settings.host = "127.0.0.1:8080" // Change port if you've configured a different one
    settings.isSSLEnabled = false // Emulator does not use SSL
              
    // Configure cache settings
    let cacheSettings = MemoryCacheSettings()
    settings.cacheSettings = cacheSettings // Disable disk persistence with in-memory cache
    firestore.settings = settings
    #endif
    
       
      

    return true
  }
    

}

@main
struct sideprojectggApp: App {
  // register app delegate for Firebase setup
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    //now we can access from any view under ContentView and update info in respective pages
    @StateObject private var viewModel = ContentViewModel()
    @StateObject private var authViewModel = AuthViewModel()

  var body: some Scene {
    WindowGroup {

          ContentView()
            .environmentObject(viewModel)
            .environmentObject(authViewModel)
              
    }
  }
}
