import SwiftUI

struct GuestView: View {
    @StateObject var appVM: AppViewModel = AppViewModel.appVM
    
    var body: some View {
        VStack {
            Text("Welcome, Guest!")
                .font(.largeTitle)
                .foregroundColor(Color.black)
                .padding()
            
            Text("Explore the app with limited access!")
                .font(.body)
                .foregroundColor(Color.black)
                .padding(.bottom, 20)

            Button(action: {
                appVM.setPageIndex(index: 0) //Go back to sign in page
            }) {
                Text("Sign in")
                    .font(Font.custom("Univers LT Std", size: 18))
                    .foregroundColor(Color.black)
                    .frame(width: 200, height: 45)
                    .cornerRadius(10)
            }
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(Color("darkBlue"))
        .ignoresSafeArea()
    }
}
