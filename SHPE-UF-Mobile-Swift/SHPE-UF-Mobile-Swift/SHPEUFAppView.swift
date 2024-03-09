

import SwiftUI

struct SHPEUFAppView: View {
    let requestHandler = RequestHandler()
    var body: some View 
    {
        SignInView(viewModel: SignInViewModel(shpeito: SHPEito()))
    }
}


#Preview {
    SHPEUFAppView()
}
