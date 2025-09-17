

import SwiftUI

/// The main application view responsible for controlling and rendering top-level screens based on the current app state.
///
/// `SHPEUFAppView` uses the shared `AppViewModel` (`appVM`) to determine which screen to display via the `pageIndex` property.
/// Depending on the index, it transitions between onboarding, authentication, and main content views, applying
/// environment objects and themes as needed.
///
/// This view also owns and manages the lifecycle of the core `DataManager`, which provides access to the Core Data context.
///
/// ## Page Index Mapping
/// - `-1`: Displays `CheckCore`, typically used for data or session validation.
/// - `0`: Shows `SignInView`, allowing user login.
/// - `1`: Shows `RegisterView`, for new user sign-up.
/// - `2`: Displays the main application interface `HomePageContentView`.
/// - `3`: Shows an additional onboarding or landing screen (`LandingPageView`).
/// - `default`: Displays an error message when an undefined index is encountered.
///
/// > Note: Each view conditionally applies the `preferredColorScheme` based on the app's dark mode setting.
///
/// - Environment Objects:
///   - `DataManager`: Provides Core Data access and app-wide shared data.
/// - Environment Values:
///   - `managedObjectContext`: Injects the Core Data context into relevant views.
struct SHPEUFAppView: View {
    @StateObject private var manager: DataManager = DataManager()
    @StateObject var appVM:AppViewModel = AppViewModel.appVM
    var body: some View
    {
        switch(appVM.pageIndex){
        case -1:
            CheckCore()
                .environmentObject(manager)
                .environment(\.managedObjectContext, manager.container.viewContext)
        case 0:
            SignInView(viewModel: SignInViewModel(shpeito: appVM.shpeito))
                .transition(.move(edge: .bottom))
                .environmentObject(manager)
                .environment(\.managedObjectContext, manager.container.viewContext)
                .preferredColorScheme(appVM.darkMode ? .dark : .light)
        case 1:
            RegisterView(viewModel: RegisterViewModel())
                .preferredColorScheme(appVM.darkMode ? .dark : .light)
        case 2:
            HomePageContentView()
                .transition(.move(edge: .trailing))
                .environmentObject(manager)
                .environment(\.managedObjectContext, manager.container.viewContext)
                .preferredColorScheme(appVM.darkMode ? .dark : .light)
        case 3:
            LandingPageView(viewModel: RegisterViewModel())
                .preferredColorScheme(appVM.darkMode ? .dark : .light)
        case 4:
            GuestPageContentView()
                .preferredColorScheme(appVM.darkMode ? .dark : .light)
        default:
            Text("Out of Index Error...")
        }
    }
}


#Preview {
    SHPEUFAppView()
}
