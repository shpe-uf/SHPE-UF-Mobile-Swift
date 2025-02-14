

import SwiftUI

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
                        GuestView()
        default:
            Text("Out of Index Error...")
        }
    }
}


#Preview {
    SHPEUFAppView()
}
