

import SwiftUI

struct GuestAboutUsView: View {
    @StateObject var appVM: AppViewModel = AppViewModel.appVM

    var body: some View {
        VStack {
            Text("Guest Information")
                .font(.largeTitle)
                .foregroundColor(Color.black)
                .padding()

            Text("Learn more about our events and opportunities!")
                .font(.body)
                .foregroundColor(Color.black)
                .padding(.bottom, 20)

            Button(action: {
                appVM.setPageIndex(index: 0) // Back to Sign In
            }) {
                Text("Sign In")
                    .font(Font.custom("Univers LT Std", size: 18))
                    .foregroundColor(Color.white)
                    .frame(width: 200, height: 45)
                    .background(Color.orange)
                    .cornerRadius(10)
            }
            .padding()

            Button(action: {
                appVM.setPageIndex(index: 5) // Navigate to Calendar
            }) {
                Text("View Events")
                    .font(Font.custom("Univers LT Std", size: 18))
                    .foregroundColor(Color.white)
                    .frame(width: 200, height: 45)
                    .background(Color.orange)
                    .cornerRadius(10)
            }
            .padding()

            Button(action: {
                appVM.setPageIndex(index: 6) // Navigate to Partners
            }) {
                Text("Our Partners")
                    .font(Font.custom("Univers LT Std", size: 18))
                    .foregroundColor(Color.white)
                    .frame(width: 200, height: 45)
                    .background(Color.orange)
                    .cornerRadius(10)
            }
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(Color("darkBlue"))
        .ignoresSafeArea()
    }
}


