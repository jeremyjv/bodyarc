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
    
    
    //we can only have one main actor, so combine everything together since we're trying to reference authViewModel from viewModel
    //LEAD Action refactor authViewModel into viewModel
    
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
