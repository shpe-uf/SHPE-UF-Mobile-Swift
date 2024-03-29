

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
                .environmentObject(manager)
                .environment(\.managedObjectContext, manager.container.viewContext)
        case 1:
            RegisterView(viewModel: RegisterViewModel())
                .transition(.move(edge: .bottom))
        case 2:
            HomePageContentView()
                .transition(.move(edge: .trailing))
                .environmentObject(manager)
                .environment(\.managedObjectContext, manager.container.viewContext)
        case 3:
            LandingPageView(viewModel: RegisterViewModel())
        default:
            Text("Out of Index Error...")
        }
    }
}


#Preview {
    SHPEUFAppView()
}
