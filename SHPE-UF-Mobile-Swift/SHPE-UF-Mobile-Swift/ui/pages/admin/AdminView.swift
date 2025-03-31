import SwiftUI

struct AdminView: View {
    var body: some View{
        NavigationStack{
            ZStack{
                Color(.darkdarkBlue)
                    .ignoresSafeArea(edges: .all)
                VStack{
                    HStack{
                        Image("Back")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .padding([.leading, .trailing, .top])
                        Spacer()
                    }
                    Text("Admin Panel")
                        .font(Font.custom("Viga-Regular", size: 28))
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .padding([.leading, .trailing, .bottom], 20 )
                    
                    ButtonGrid()
                }
            }
        }
    }
}

struct ButtonGrid: View {
    
    var body: some View{
        ScrollView{
            VStack(spacing: 35){
                HStack{
                    AdminButton(symbol: "Event", label: "Events", color: .rblue)
                    Spacer()
                    AdminButton(symbol: "dark_customer", label: "Members", color: .rblue)
                }
                HStack{
                    AdminButton(symbol: "Resources", label: "Resources", color: .lorange)
                    Spacer()
                    AdminButton(symbol: "Requests", label: "Requests", color: .lorange)
                }
                HStack{
                    AdminButton(symbol: "Stat", label: "Statistics", color: .rblue)
                    Spacer()
                    AdminButton(symbol: "Database", label: "Corporate Database", color: .rblue)
                }
                HStack{
                    AdminButton(symbol: "Money", label: "Reimburse", color: .lorange)
                    Spacer()
                    AdminButton(symbol: "Key", label: "SHPE Rentals", color: .lorange)
                }
            }
            .padding(.horizontal, 20)
        }
    }
}

struct AdminButton: View {
    var symbol : String
    var label : String
    var color : Color
    
    var body : some View{
        NavigationLink(destination: destinationSelector(label: label)){
            ZStack{
                RoundedRectangle(cornerRadius: 8)
                    .fill(color)
                    .frame(width: 170, height: 150)
                VStack{
                    Image(symbol)
                        .frame(width: 55, height: 55)
            
                    Text(label)
                        .font(Font.custom("Viga-Regular", size: 26))
                        .foregroundColor(.white)
                }
                
            }
        }
    }
}

@ViewBuilder
func destinationSelector(label: String) -> some View{
    switch label{
        case "Events":
            EventCreatorView()
        case "Members":
            ComingSoonView()
        case "Resources":
            ComingSoonView()
        case "Requests":
            ComingSoonView()
        case "Statistics":
            ComingSoonView()
        case "Corporate Database":
            ComingSoonView()
        case "Reimburse":
            ComingSoonView()
        case "SHPE Rentals":
            ComingSoonView()
        default:
            Text("Label not found")
    }
}

#Preview {
    AdminView()
}
