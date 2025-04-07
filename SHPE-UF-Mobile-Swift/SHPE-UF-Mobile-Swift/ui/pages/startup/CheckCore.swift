//
//  CheckCore.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by Daniel Parra on 3/10/24.
//

import SwiftUI
/// A view that serves as the initial entry point for the SHPE app, checking for existing user data.
///
/// `CheckCore` functions as a splash screen that appears when the app launches. During this time,
/// it performs critical initialization tasks:
///
/// - Checks for existing user data in Core Data
/// - Initializes the app's appearance settings based on system preferences
/// - Determines whether to direct the user to the login flow or main app interface
///
/// This view displays a branded start screen image while these background operations complete,
/// creating a seamless transition into the appropriate next view based on authentication status.
///
/// ## Initialization Process
///
/// When `CheckCore` appears, it performs these operations in sequence:
/// 1. Sets the app's dark mode state to match the system color scheme
/// 2. Checks if user data exists in Core Data through the `CheckCoreViewModel`
/// 3. Automatically navigates to either the sign-in screen or main app based on the result
///
/// ## View Hierarchy
///
/// `CheckCore` sits at the root of the app's view hierarchy during launch and is typically
/// inserted into the app's initial `WindowGroup` in the SwiftUI lifecycle.
///
/// ## Example
///
/// ```swift
/// @main
/// struct SHPEUFMobileApp: App {
///     let persistenceController = PersistenceController.shared
///     @StateObject var dataManager = DataManager()
///
///     var body: some Scene {
///         WindowGroup {
///             CheckCore()
///                 .environment(\.managedObjectContext, persistenceController.container.viewContext)
///                 .environmentObject(dataManager)
///         }
///     }
/// }
/// ```
struct CheckCore: View {
    @EnvironmentObject var manager: DataManager
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.colorScheme) private var colorScheme
    @FetchRequest(sortDescriptors: []) private var user: FetchedResults<User>
    @StateObject var appVM:AppViewModel = AppViewModel.appVM
    @StateObject var viewModel:CheckCoreViewModel = CheckCoreViewModel()
    
    /// The view's body, displaying a full-screen start image and performing initialization checks
    var body: some View {
        Image("StartScreen")
            .resizable()
            .frame(width: UIScreen.main.bounds.width)
            .aspectRatio(contentMode: .fill)
            .ignoresSafeArea()
            .onAppear(perform: {
                appVM.darkMode = colorScheme == .dark
                viewModel.checkUserInCore(user: user)
            })
            
    }
}

#Preview {
    CheckCore()
}
