

import SwiftUI

struct SHPEUFAppView: View {
    let requestHandler = RequestHandler()
    var body: some View 
    {
        RegisterView()
       // AcademicView(viewModel: RegisterViewModel())
        
            .onAppear {
                print("I HAVE APPEARED")
            }
//        PointsView(vm: PointsViewModel(shpeito: SHPEito(id: "64f7d5ce08f7e8001456248a", name: "Daniel Parra", points: 0)))
    }
}


#Preview {
    SHPEUFAppView()
}
