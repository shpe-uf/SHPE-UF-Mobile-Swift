

import SwiftUI

struct SHPEUFAppView: View {
    @StateObject var appVM:AppViewModel = AppViewModel.appVM
    var body: some View
    {
        switch(appVM.pageIndex){
        case -1:
            SignInView(viewModel: SignInViewModel(shpeito: SHPEito()))
        case 0:
            RegisterView(viewModel: RegisterViewModel())
        default:
            Text("Out of Index Error...")
        }
    }
}


#Preview {
    SHPEUFAppView()
}
