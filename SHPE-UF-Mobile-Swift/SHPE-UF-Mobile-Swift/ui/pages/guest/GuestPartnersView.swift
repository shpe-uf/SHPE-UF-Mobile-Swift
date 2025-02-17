import SwiftUI

struct GuestPartnersView: View {
    @StateObject var appVM: AppViewModel = AppViewModel.appVM

    var body: some View {
        VStack {
            Text("Our Partners")
                .font(.largeTitle)
                .foregroundColor(Color.black)
                .padding()

            Text("Meet the companies that support us!")
                .font(.body)
                .foregroundColor(Color.black)
                .padding(.bottom, 20)

            Button(action: {
                appVM.setPageIndex(index: 4) // Back to Guest Info
            }) {
                Text("Back to Info")
                    .font(Font.custom("Univers LT Std", size: 18))
                    .foregroundColor(Color.white)
                    .frame(width: 200, height: 45)
                    .background(Color.gray)
                    .cornerRadius(10)
            }
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(Color("darkBlue"))
        .ignoresSafeArea()
    }
}
#Preview {
    GuestPartnersView()
}
