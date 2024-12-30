//
//  sideprojectggApp.swift
//  sideprojectgg
//
//  Created by Jeremy Villanueva on 12/2/24.
//

import SwiftUI
import Firebase



class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    
       
      

    return true
  }
    
//    func makeReservation() {
//            let db = Firestore.firestore()
//            // Add the necessary Firebase instructions to create the reservation record.
//        }
}

@main
struct sideprojectggApp: App {
  // register app delegate for Firebase setup
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    //now we can access from any view under ContentView and update info in respective pages
    @StateObject private var viewModel = ContentViewModel()

  var body: some Scene {
    WindowGroup {

          ContentView()
            .environmentObject(viewModel)
              
    }
  }
}
