 import SwiftUI

struct GuestPartnersView: View {
    @StateObject var appVM: AppViewModel = AppViewModel.appVM
    @State private var showCalendar = false

    struct Constants {
        static let Orange: Color = Color(red: 0.82, green: 0.35, blue: 0.09)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                ZStack {
                    Rectangle()
                        .frame(width: UIScreen.main.bounds.width, height: 93)
                        .foregroundColor(Constants.Orange)
                        .edgesIgnoringSafeArea(.top)

                    HStack(spacing: 20) {
                        Text("Partners")
                            .font(Font.custom("Viga", size: 24))
                            .foregroundColor(.white)
                            .padding(.leading, 10)
                            .padding(.top, 31)

                        Spacer()

                        Button(action: {
                            appVM.setPageIndex(index: 0)
                        }) {
                            HStack(spacing: 4) {
                                Text("Login")
                                    .font(Font.custom("UniversLTStd", size: 20))
                                    .foregroundColor(.white)

                                Image("Login")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(.white)

                            }
                        }
                        .padding(.top, 31)
                        .padding(.trailing, 10)
                    }

                }

                // Gold Partners
                Text("GOLD PARTNERS")
                    .font(Font.custom("Viga", size: 24))
                    .foregroundColor(Color(red: 0.83, green: 0.69, blue: 0))
                    .frame(width: 258, height: 24)

                HStack(spacing: 16) {
                    partnerBox(image: "Capital_One", width: 100, height: 100, shadow: Color(red: 0.83, green: 0.69, blue: 0))
                    partnerBox(image: "Edwards", width: 80, height: 80, shadow: Color(red: 0.83, green: 0.69, blue: 0))
                }

                // Silver Partners
                Text("SILVER PARTNERS")
                    .font(Font.custom("Viga", size: 24))
                    .foregroundColor(Color(red: 0.55, green: 0.55, blue: 0.55))
                    .frame(width: 258, height: 24)

                LazyVGrid(columns: Array(repeating: GridItem(.fixed(96)), count: 3), spacing: 16) {
                    partnerBox(image: "ABB", width: 80, height: 80, shadow: .gray)
                    partnerBox(image: "Accenture", width: 80, height: 80, shadow: .gray)
                    partnerBox(image: "BOFA", width: 80, height: 80, shadow: .gray)
                    partnerBox(image: "Bloomberg", width: 90, height: 90, shadow: .gray)
                    partnerBox(image: "BlueOrigin", width: 100, height: 100, shadow: .gray)
                    partnerBox(image: "CDM_Smith", width: 80, height: 80, shadow: .gray)
                    partnerBox(image: "ExxonMobil", width: 110, height: 110, shadow: .gray)

                    ForEach(9..<21) { _ in
                        placeholderBox(shadow: .gray)
                    }
                }

                // Bronze Partners
                Text("BRONZE PARTNERS")
                    .font(Font.custom("Viga", size: 24))
                    .foregroundColor(Color(red: 0.81, green: 0.54, blue: 0.27))
                    .frame(width: 258, height: 24)

                LazyVGrid(columns: Array(repeating: GridItem(.fixed(96)), count: 3), spacing: 16) {
                    ForEach(0..<11) { _ in
                        placeholderBox(shadow: Color(red: 0.81, green: 0.54, blue: 0.27))
                    }
                }
                Text("Interested in becoming\n a partner?")
                    .font(Font.custom("Viga", size: 24))
                    .foregroundColor(Color.primary) // Adapts to light/dark mode
                    .multilineTextAlignment(.center)

                // Contact Us Button
                Button(action: {
                    if let url = URL(string: "mailto:vpcorporate.shpeuf@gmail.com") {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }) {
                    Text("Contact us")
                        .font(Font.custom("Viga", size: 24))
                        .foregroundColor(.white)
                        .frame(width: 180, height: 56)
                        .background(Constants.Orange)
                        .cornerRadius(20)
                }


                Spacer(minLength: 30)
            }
            .padding(.bottom, 30)
        }
        .frame(width: UIScreen.main.bounds.width)
        .background(Color("darkBlue"))
        .ignoresSafeArea()
        
    }

    // MARK: - Partner Image Boxes

    func partnerBox(image: String, width: CGFloat, height: CGFloat, shadow: Color) -> some View {
        Rectangle()
            .foregroundColor(.clear)
            .frame(width: 96, height: 96)
            .background(Color.white)
            .shadow(color: shadow, radius: 4)
            .overlay(
                Image(image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: width, height: height)
            )
    }

    func placeholderBox(shadow: Color) -> some View {
        Rectangle()
            .foregroundColor(.clear)
            .frame(width: 96, height: 96)
            .background(Color.white)
            .shadow(color: shadow, radius: 4)
    }
}
#Preview {
    GuestPartnersView()
}
