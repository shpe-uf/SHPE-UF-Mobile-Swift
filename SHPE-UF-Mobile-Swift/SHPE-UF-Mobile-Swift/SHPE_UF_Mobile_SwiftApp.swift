//
//  SHPE_UF_Mobile_SwiftApp.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by Jesus Lopez on 10/19/23.
//

import SwiftUI

@main
struct SHPE_UF_Mobile_SwiftApp: App {
    @StateObject private var manager: DataManager = DataManager()
    var body: some Scene {
        WindowGroup {
            SignInView()
                .environmentObject(manager)
                .environment(\.managedObjectContext, manager.container.viewContext)
        }
    }
}
