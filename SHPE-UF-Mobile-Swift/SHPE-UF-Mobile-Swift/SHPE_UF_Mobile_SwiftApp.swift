//
//  SHPE_UF_Mobile_SwiftApp.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by Jesus Lopez on 10/19/23.
//

import SwiftUI

/// The main entry point for the SHPE UF Mobile application.
///
/// This struct:
/// 1. Initializes the application window and root view
/// 2. Sets up the Core Data model container for map placemarks
/// 3. Serves as the configuration point for the app's scene
///
/// ## Key Responsibilities
/// - Creates the main window group with `SHPEUFAppView` as root view
/// - Configures the Core Data model container for `MTPlacemark` entities
/// - Handles app lifecycle events
///
/// ## Usage
/// The `@main` attribute identifies this as the app's entry point. The system:
/// 1. Creates the app instance when launched
/// 2. Initializes the window group
/// 3. Loads the Core Data container
///
/// ## Example Configuration
/// No direct instantiation needed - SwiftUI manages this automatically.
@main
struct SHPE_UF_Mobile_SwiftApp: App {
    @StateObject private var locationManager = LocationManager()
    init() {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithTransparentBackground()
        tabBarAppearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial) // or .light / .dark
        tabBarAppearance.backgroundColor = .clear

        UITabBar.appearance().standardAppearance = tabBarAppearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }
    }
    
    var body: some Scene {
        WindowGroup {
            SHPEUFAppView()
                .environmentObject(locationManager)
        }
        .modelContainer(for: MTPlacemark.self) { result in
            debugPrint("data container ready")
        }
    }
}
