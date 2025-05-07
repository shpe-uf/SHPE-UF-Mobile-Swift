import SwiftUI
import CoreData

struct GuestPartnersView: View {
  @StateObject var appVM: AppViewModel = AppViewModel.appVM
  @Environment(\.colorScheme) var colorScheme
  @State private var partners: [SHPESchema.GetPartnersQuery.Data.GetPartner] = []
  private let request = RequestHandler()


    var body: some View {
        VStack(spacing: 0)
        {
            ZStack(alignment: .center){
                Constants.orange
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
            
            
            ZStack
            {
                
                
                ScrollView {
                    //Gold, Silver, Bronze Sections
                    partnerSection(
                        title: "GOLD PARTNERS",
                        titleColor: Color(red: 0.83, green: 0.69, blue: 0),
                        items: partners.filter { $0.tier.lowercased() == "gold" }
                    )
                    
                    partnerSection(
                        title: "SILVER PARTNERS",
                        titleColor: Color(red: 0.55, green: 0.55, blue: 0.55),
                        items: partners.filter { $0.tier.lowercased() == "silver" }
                    )
                    
                    partnerSection(
                        title: "BRONZE PARTNERS",
                        titleColor: Color(red: 0.81, green: 0.54, blue: 0.27),
                        items: partners.filter { $0.tier.lowercased() == "bronze" }
                    )
                    
                    Text("Interested in becoming\n a partner?")
                        .font(Font.custom("Viga", size: 24))
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.center)
                    
                    Button(action: {
                        if let url = URL(string: "mailto:vpcorporate.shpeuf@gmail.com") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        Text("Contact us")
                            .font(Font.custom("Viga", size: 24))
                            .foregroundColor(.white)
                            .frame(width: 180, height: 56)
                            .background(Constants.orange)
                            .cornerRadius(20)
                    }
                    
                    Spacer(minLength: 30)
                }
                .padding(.bottom, 55)
                .padding(.top, 20)
                .onAppear {
                    request.fetchPartners { fetched in
                        DispatchQueue.main.async { partners = fetched }
                    }
                }
            }
            .frame(width: UIScreen.main.bounds.width)
            .background(Color("darkBlue"))
            .ignoresSafeArea()
        }
        .background(colorScheme == .dark ? Constants.darkModeBackground : Constants.BackgroundColor)
        .edgesIgnoringSafeArea(.all)
    }
    

  @ViewBuilder
  private func partnerSection(
    title: String,
    titleColor: Color,
    items: [SHPESchema.GetPartnersQuery.Data.GetPartner]
  ) -> some View {
    // Title
    Text(title)
      .font(Font.custom("Viga", size: 24))
      .foregroundColor(titleColor)
      .frame(width: 258, height: 24)
      .padding(.bottom, 8)

    // If 1–3 items, use a centered HStack; otherwise 3-column grid
    if items.count <= 3 {
      HStack(spacing: 16) {
        ForEach(items, id: \.name) { p in
          partnerBox(
            imageURL: p.photo,
            width: 80, height: 80,
            shadow: titleColor
          )
        }
      }
      .frame(maxWidth: .infinity, alignment: .center)
      .padding(.bottom, 16)
    } else {
      LazyVGrid(
        columns: Array(repeating: GridItem(.fixed(96)), count: 3),
        spacing: 16
      ) {
        ForEach(items, id: \.name) { p in
          partnerBox(
            imageURL: p.photo,
            width: 80, height: 80,
            shadow: titleColor
          )
        }
      }
      .padding(.bottom, 16)
    }
  }

  
  // Partner Box
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
            ProgressView().frame(width: width, height: height)
          case .success(let img):
            img.resizable()
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
}

#Preview {
  GuestPartnersView()
}
