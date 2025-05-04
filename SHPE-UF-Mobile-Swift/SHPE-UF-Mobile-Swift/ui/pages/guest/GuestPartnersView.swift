import SwiftUI

struct GuestPartnersView: View {
  @StateObject var appVM: AppViewModel = AppViewModel.appVM
  @State private var partners: [SHPESchema.GetPartnersQuery.Data.GetPartner] = []
  private let request = RequestHandler()

  struct Constants {
    static let Orange = Color(red: 0.82, green: 0.35, blue: 0.09)
  }

  var body: some View {
    
      VStack(spacing: 20) {
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

            Button(action: { appVM.setPageIndex(index: 0) }) {
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
    ScrollView {
        // ─── Gold Partners ────────────────────────────────────────────────────
        Text("GOLD PARTNERS")
          .font(Font.custom("Viga", size: 24))
          .foregroundColor(Color(red: 0.83, green: 0.69, blue: 0))
          .frame(width: 258, height: 24)

        HStack(spacing: 16) {
          ForEach(partners.filter { $0.tier.lowercased() == "gold" },
                  id: \.name) { p in
            partnerBox(
              imageURL: p.photo,
              width: 80, height: 80,
              shadow: Color(red: 0.83, green: 0.69, blue: 0)
            )
          }
        }

        // ─── Silver Partners ──────────────────────────────────────────────────
        Text("SILVER PARTNERS")
          .font(Font.custom("Viga", size: 24))
          .foregroundColor(Color(red: 0.55, green: 0.55, blue: 0.55))
          .frame(width: 258, height: 24)

        LazyVGrid(
          columns: Array(repeating: GridItem(.fixed(96)), count: 3),
          spacing: 16
        ) {
          ForEach(partners.filter { $0.tier.lowercased() == "silver" },
                  id: \.name) { p in
            partnerBox(imageURL: p.photo, width: 80, height: 80, shadow: .gray)
          }
        }

        // ─── Bronze Partners ──────────────────────────────────────────────────
        Text("BRONZE PARTNERS")
          .font(Font.custom("Viga", size: 24))
          .foregroundColor(Color(red: 0.81, green: 0.54, blue: 0.27))
          .frame(width: 258, height: 24)

        LazyVGrid(
          columns: Array(repeating: GridItem(.fixed(96)), count: 3),
          spacing: 16
        ) {
          ForEach(partners.filter { $0.tier.lowercased() == "bronze" },
                  id: \.name) { p in
            partnerBox(
              imageURL: p.photo,
              width: 80, height: 80,
              shadow: Color(red: 0.81, green: 0.54, blue: 0.27)
            )
          }
        }

        Text("Interested in becoming\n a partner?")
          .font(Font.custom("Viga", size: 24))
          .foregroundColor(.primary)
          .multilineTextAlignment(.center)

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
      .padding(.bottom, 55)
      .onAppear {
        request.fetchPartners { fetched in
          DispatchQueue.main.async {
            partners = fetched
          }
        }
      }
    }
    .frame(width: UIScreen.main.bounds.width)
    .background(Color("darkBlue"))
    .ignoresSafeArea()

  }

  // ───────────────────────────────────────────────────────────────────────────
  // MARK: - Partner Boxes
  // ───────────────────────────────────────────────────────────────────────────

  private func partnerBox(
    imageURL: String,
    width: CGFloat,
    height: CGFloat,
    shadow: Color
  ) -> some View {
    Rectangle()
      .foregroundColor(.clear)
      .frame(width: 96, height: 96)
      .background(Color.white)
      .shadow(color: shadow, radius: 4)
      .overlay {
        AsyncImage(url: URL(string: imageURL)) { phase in
          switch phase {
          case .empty:
            ProgressView()
              .frame(width: width, height: height)
          case .success(let img):
            img
              .resizable()
              .scaledToFit()
              .frame(width: width, height: height)
          case .failure:
            Image(systemName: "photo")
              .resizable()
              .scaledToFit()
              .frame(width: width, height: height)
              .foregroundColor(.gray)
          @unknown default:
            EmptyView()
          }
        }
      }
  }

  private func placeholderBox(shadow: Color) -> some View {
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
