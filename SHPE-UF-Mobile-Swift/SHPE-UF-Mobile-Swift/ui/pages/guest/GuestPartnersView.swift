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
                ZStack(alignment: .center) {
                    Constants.Orange
                        .frame(width: UIScreen.main.bounds.width, height: 100)
                    
                    HStack(spacing: 20) {
                        Text("Partners")
                            .font(Font.custom("Viga-Regular", size: 24))
                            .foregroundColor(.white)
                            .frame(height: 0, alignment: .topLeading)
                        
                        Spacer()
                        
                        Button(action: {
                            appVM.setPageIndex(index: 0)
                        }) {
                            HStack {
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
                        .padding(.top, 10)
                        .frame(height: 0, alignment: .topLeading)
                    }
                    .padding(.horizontal, UIScreen.main.bounds.width * 0.05)
                }


                // Gold Partners
                sectionTitle("GOLD PARTNERS", color: Color(red: 0.83, green: 0.69, blue: 0))
                HStack(spacing: 16) {
                    placeholderBox(shadow: Color(red: 0.83, green: 0.69, blue: 0))
                    placeholderBox(shadow: Color(red: 0.83, green: 0.69, blue: 0))
                }

                // Silver Partners (22 Partners)
                sectionTitle("SILVER PARTNERS", color: Color(red: 0.55, green: 0.55, blue: 0.55))
                LazyVGrid(columns: Array(repeating: GridItem(.fixed(96)), count: 3), spacing: 16) {
                    ForEach(0..<22) { _ in // 22 Silver Partners
                        placeholderBox(shadow: .gray)
                    }
                }

                // Bronze Partners (11 Partners)
                sectionTitle("BRONZE PARTNERS", color: Color(red: 0.81, green: 0.54, blue: 0.27))
                LazyVGrid(columns: Array(repeating: GridItem(.fixed(96)), count: 3), spacing: 16) {
                    ForEach(0..<11) { _ in // 11 Bronze Partners
                        placeholderBox(shadow: Color(red: 0.81, green: 0.54, blue: 0.27))
                    }
                }


                // Contact Us Button
                actionButton("Contact us", color: Constants.Orange) {
                    if let url = URL(string: "https://mailto:vpcorporate.shpeuf@gmail.com") {
                        UIApplication.shared.open(url)
                    }
                }

                Spacer(minLength: 30)
            }
            .padding(.bottom, 90)
        }
        .frame(width: UIScreen.main.bounds.width)
        .background(Color("darkBlue"))
        .ignoresSafeArea()
    }

    // MARK: - Helper Views

    func sectionTitle(_ text: String, color: Color) -> some View {
        Text(text)
            .font(Font.custom("Viga", size: 24))
            .foregroundColor(color)
            .frame(width: 258, height: 24)
    }

    func placeholderBox(shadow: Color) -> some View {
        Rectangle()
            .fill(Color.white)
            .frame(width: 96, height: 96)
            .shadow(color: shadow, radius: 4)
    }

    func actionButton(_ title: String, color: Color, fontSize: CGFloat = 24, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(Font.custom("Viga", size: fontSize))
                .foregroundColor(.white)
                .frame(height: 56)
                .frame(minWidth: 180)
                .padding(.horizontal, 20)
                .background(color)
                .cornerRadius(20)
        }
    }
}
