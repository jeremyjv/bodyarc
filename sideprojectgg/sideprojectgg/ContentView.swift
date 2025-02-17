//
//  ContentView.swift
//  sideprojectgg
//
//  Created by Jeremy Villanueva on 12/2/24.
//
import Foundation
import SwiftUI
import Firebase
import FirebaseFunctions
import PhotosUI
import RevenueCat




struct ContentView: View {
    
    @EnvironmentObject var viewModel: ContentViewModel
    @State var path = NavigationPath()
    @StateObject private var cameraModel = CameraModel()
    
    init() {
        configureTabBarAppearance()
    }

    var body: some View {
        if viewModel.isLoggedIn {
            NavigationStack(path: $path) {
                TabView(selection: $viewModel.selectedTab) {
                    
                    ScanView(path: $path)
                        .tabItem {
                            VStack {
                                Image("scan") // Reference the asset name
                                    .renderingMode(.template) // Ensure it adopts the foreground color
                                Text("Scan")
                            }
                        }
                        .tag("ScanView")

                    ProgressView(retrievedScanImages: $viewModel.retrievedScanImages, scans: $viewModel.scans, path: $path)
                        .tabItem {
                            VStack {
                                Image("chart-no-axes-combined") // Replace with your asset name
                                    .renderingMode(.template)
                                Text("Progress")
                            }
                        }
                        .tag("ProgressView")

                    RoutineView(path: $path)
                        .tabItem {
                            VStack {
                                Image("dumbbell") // Replace with your asset name
                                    .renderingMode(.template)
                                Text("Grow")
                            }
                        }
                        .tag("RoutineView")
                }
                .onAppear {
                    configureTabBarAppearance()
                }
                .navigationDestination(for: String.self) { destination in
                    switch destination {
                    case "FrontInstructionsView":
                        FrontInstructionsView(path: $path)
                    case "FrontScanView":
                        FrontScanView(path: $path)
                    case "BackScanView":
                        BackScanView(path: $path)
                    case "PaywallView":
                        PaywallView()
                    case "ScanEdgeView":
                        ScanEdgeView(path: $path)
                    case "InstaScanPaywallView":
                        InstaScanPaywallView(path: $path)
                    case "ProgressView":
                        ProgressView(retrievedScanImages: $viewModel.retrievedScanImages, scans: $viewModel.scans, path: $path)
                        
                    case "DailyProgressPicturesView":
                        DailyProgressPicturesView(path: $path)
                        
                    case "FrontProgressScanView":
                        FrontProgressScanView(path: $path)
                    case "BackProgressScanView":
                        BackProgressScanView(path: $path)
                    default:
                        ContentView()
                    }
                }
                .navigationDestination(for: ScanObject.self) { scan in
                    RatingView(scanObject: scan, path: $path)
                }
                .gesture(DragGesture().onChanged { _ in })
            }
        } else {
            GenderView()
        }
    }
    
    private func configureTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.shadowColor = nil
        appearance.backgroundColor = UIColor(red: 15/255, green: 15/255, blue: 15/255, alpha: 1.0) // Change this to your desired solid color
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}


#Preview {
    ContentView()
}
