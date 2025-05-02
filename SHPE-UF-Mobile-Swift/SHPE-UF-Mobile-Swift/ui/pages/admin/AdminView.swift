import SwiftUI

struct AdminView: View {
    var body: some View{
        NavigationStack{
            ZStack{
                Color(.darkdarkBlue)
                    .ignoresSafeArea(edges: .all)
                VStack{
                    HStack(){
                        Image("Back")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .padding(.trailing, UIScreen.main.bounds.width * 0.10)
                        
                        Text("Admin Panel")
                            .font(Font.custom("Viga-Regular", size: 28))
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .padding(.trailing, UIScreen.main.bounds.width * 0.20)
                            
                    }
                    .padding(UIScreen.main.bounds.width * 0.05)
                    
                    ButtonGrid()
                }
            }
        }
    }
}

struct ButtonGrid: View {
    
    var body: some View{
        ScrollView{
            VStack(spacing: UIScreen.main.bounds.height * 0.035){
                HStack{
                    AdminButton(symbol: "Event", label: "Events", color: .adminBlue, enabled: true)
                    Spacer()
                    AdminButton(symbol: "dark_customer", label: "Members", color: .adminBlue)
                }
                HStack{
                    AdminButton(symbol: "Resources", label: "Resources", color: .adminOrange)
                    Spacer()
                    AdminButton(symbol: "Requests", label: "Requests", color: .adminOrange)
                }
                HStack{
                    AdminButton(symbol: "Stat", label: "Statistics", color: .adminBlue)
                    Spacer()
                    AdminButton(symbol: "Database", label: "Corporate Database", color: .adminBlue)
                }
                HStack{
                    AdminButton(symbol: "Money", label: "Reimburse", color: .adminOrange)
                    Spacer()
                    AdminButton(symbol: "Key", label: "SHPE Rentals", color: .adminOrange)
                }
            }
            .padding(.horizontal, UIScreen.main.bounds.width * 0.070)
        }
    }
}

struct AdminButton: View {
    var symbol : String
    var label : String
    var color : Color
    var enabled: Bool = false
    
    var recWidth  : CGFloat = UIScreen.main.bounds.width  * 0.40
    var recHeight : CGFloat = UIScreen.main.bounds.height * 0.17
    
    var frameWidth : CGFloat = UIScreen.main.bounds.width  * 0.1
    var frameHeight = UIScreen.main.bounds.height  * 0.05
    
    var body : some View{
        if enabled {
                  NavigationLink(destination: destinationSelector(label: label)) {
                      ZStack {
                          RoundedRectangle(cornerRadius: 8)
                              .fill(color)
                              .frame(width: recWidth, height: recHeight)
                          VStack {
                              Image(symbol)
                                  .resizable()
                                  .frame(width: frameWidth, height: frameHeight)
                                  .padding(.top, UIScreen.main.bounds.height * 0.015)
                              
                              Text(label)
                                  .font(Font.custom("Viga-Regular", size: 26))
                                  .foregroundColor(.white)
                          }
                      }
                  }
              } else {
                  ZStack {
                      RoundedRectangle(cornerRadius: 8)
                          .fill(color)
                          .frame(width: recWidth, height: recHeight)
                      VStack {
                          Image(symbol)
                              .resizable()
                              .frame(width: frameWidth, height: frameHeight)
                              .padding(.top, UIScreen.main.bounds.height * 0.015)
                          
                          Text(label)
                              .font(Font.custom("Viga-Regular", size: 26))
                              .foregroundColor(.white)
                      }
                  }
                  .opacity(0.4)
              }
    }
}

@ViewBuilder
func destinationSelector(label: String) -> some View{
    switch label{
        case "Events":
            EventCreatorView()
        default:
            AdminView()
    }
}

#Preview {
    AdminView()
}
