//
//  SHPE_UF_Mobile_SwiftApp.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by Jesus Lopez on 10/19/23.
//

import SwiftUI

@main
struct SHPE_UF_Mobile_SwiftApp: App {
    var body: some Scene {
        WindowGroup {
            SHPEUFAppView()
        }
        .modelContainer(for: MTPlacemark.self) { result in
            debugPrint("data container ready")
        }
    }
}
