import SwiftUI

struct GuestPartnersView: View {
    @StateObject var appVM: AppViewModel = AppViewModel.appVM
    @State private var showCalendar = false

    struct Constants {
        static let Orange: Color = Color(red: 0.82, green: 0.35, blue: 0.09)
    }

    // MARK: - Partner Images
    let goldPartnerImages = ["CapitalOne", "Edwards"]
    let silverPartnerImages = [
        "ABB", "Accenture", "BOFA", "Bloomberg", "BlueOrigin", "CDMSmith", "ExxonMobil", "GEAero", "GeneralMills", "KimleyHorn", "LockheedMartin", "Lutron",
        "Medtronic", "Micron", "NVIDIA", "Pepsico", "PG", "Sandia", "Southern", "Trinity", "WT", "WadeTrim"
    ]
    let bronzePartnerImages = [
        "Disney", "GEV", "Google", "Honeywell", "JPMorgan", "JaneStreet", "LJA", "Microsoft", "SpaceX", "TI", "UKG"
    ]

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
                LazyVGrid(columns: [GridItem(.fixed(96)), GridItem(.fixed(96))], spacing: 16) {
                    ForEach(goldPartnerImages.indices, id: \.self) { index in
                        imageBox(named: goldPartnerImages[index], shadow: Color(red: 0.83, green: 0.69, blue: 0))
                    }
                }

                // Silver Partners
                sectionTitle("SILVER PARTNERS", color: Color(red: 0.55, green: 0.55, blue: 0.55))
                LazyVGrid(columns: Array(repeating: GridItem(.fixed(96)), count: 3), spacing: 16) {
                    ForEach(silverPartnerImages.indices, id: \.self) { index in
                        imageBox(named: silverPartnerImages[index], shadow: .gray)
                    }
                }

                // Bronze Partners
                sectionTitle("BRONZE PARTNERS", color: Color(red: 0.81, green: 0.54, blue: 0.27))
                LazyVGrid(columns: Array(repeating: GridItem(.fixed(96)), count: 3), spacing: 16) {
                    ForEach(bronzePartnerImages.indices, id: \.self) { index in
                        imageBox(named: bronzePartnerImages[index], shadow: Color(red: 0.81, green: 0.54, blue: 0.27))
                    }
                }

                // Contact Us Button
                actionButton("Contact us", color: Constants.Orange) {
                    if let url = URL(string: "mailto:vpcorporate.shpeuf@gmail.com") {
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

    func imageBox(named imageName: String, shadow: Color) -> some View {
        ZStack {
            Rectangle()
                .fill(Color.white)
                .frame(width: 96, height: 96)
                .shadow(color: shadow, radius: 4)

            if !imageName.isEmpty {
                let zoomedLogos: Set<String> = ["Bloomberg", "BlueOrigin", "ExxonMobil", "GEAero", "NVIDIA", "Pepsico", "Disney", "GEV"]
                let isZoomed = zoomedLogos.contains(imageName)
                let isExtraZoomed = imageName == "GeneralMills"

                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(
                        width: isExtraZoomed ? 96 : (isZoomed ? 90 : 80),
                        height: isExtraZoomed ? 96 : (isZoomed ? 90 : 80)
                    )
                    .offset(x: imageName == "SpaceX" ? 5 : 0)
            }
        }
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
