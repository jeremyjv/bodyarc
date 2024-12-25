//
//  ViewController.swift
//  sideprojectgg
//
//  Created by Jeremy Villanueva on 12/6/24.
//

import SwiftUI
import Firebase
import FirebaseFirestore

private func emulatorSettings() {
  // [START fs_emulator_connect]
    let settings = Firestore.firestore().settings
    settings.host = "127.0.0.1:5001"
    settings.cacheSettings = MemoryCacheSettings()
    settings.isSSLEnabled = false
    Firestore.firestore().settings = settings
  // [END fs_emulator_connect]
}
