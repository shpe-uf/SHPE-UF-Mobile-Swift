import SwiftUI

struct EventCreatorView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var eventVM = EventCreatorViewModel()
    @StateObject var appVM:AppViewModel = AppViewModel.appVM
    @State var showPopup: Bool = false
    
    var body: some View{
        
        ZStack{

            VStack{
                ZStack{
                    Image(appVM.darkMode ? "Gator" : "Gator2")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: UIScreen.main.bounds.width * 0.5, height: UIScreen.main.bounds.height * 0.150)
                        .offset(x:-UIScreen.main.bounds.width*0.42, y: appVM.darkMode ? 40 : 30)
                      
                    
                    
                    CurvedTopRectangle(cornerRadius: 10, curveHeight: 100)
                        .fill(Color("Profile-Background"))
                        .frame(width: UIScreen.main.bounds.width * 1.9, height: UIScreen.main.bounds.height * 0.2)
                        .padding(.top, UIScreen.main.bounds.height * 0.17)
                    
                
                    Image("EVENTS")
                        .resizable()
                        .frame(width: UIScreen.main.bounds.width * 0.375, height: UIScreen.main.bounds.height * 0.0360, alignment: .center)
                                        
                        
                    Image("Edit Event")
                        .resizable()
                        .frame(width: UIScreen.main.bounds.width * 0.35, height: UIScreen.main.bounds.width * 0.065, alignment: .trailing)
                        .padding(.top, UIScreen.main.bounds.height * 0.225)
                        .padding(.trailing, UIScreen.main.bounds.width * 0.52)
                }
                .frame(maxWidth:.infinity)
                .background(Color("profile-orange"))
                
                ScrollView{
                    
                    InputGrid(vm : eventVM)
                        .padding(.leading, UIScreen.main.bounds.width * 0.05)
                        .frame(width: UIScreen.main.bounds.width)
                        .padding(.bottom, 100)
                }
                HStack(spacing: 0){
                    
                    Button {
                        dismiss()
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color("buttonColor"))
                                .stroke(.white, lineWidth: 2)
                                .frame(width: 160, height: 50)
                                .padding()
                            
                            Text("Cancel")
                                .font(Font.custom("Viga-Regular", size: 25))
                                .foregroundColor(.white)
                        }
                    }
                    
                    Button {
                        eventVM.SaveEvent()
                        showPopup.toggle()
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color("buttonColor"))
                                .stroke(.white, lineWidth: 2)
                                .frame(width: 160, height: 50)
                                .padding()
                            
                            Text("Save")
                                .font(Font.custom("Viga-Regular", size: 25))
                                .foregroundColor(.white)
                        }
                    }
                }
                .padding(.bottom, 30)
                .zIndex(10)
            }
            .ignoresSafeArea()
            .background(Color("Profile-Background"))
            .preferredColorScheme(appVM.darkMode ? .dark : .light)
            .blur(radius: showPopup ? 5 : 0)
            
            if showPopup{
                Color.clear
                    .contentShape(Rectangle())
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation{
                            showPopup.toggle()
                        }
                    }
                ConfirmPopUp(isShowing: $showPopup)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
   
}

struct ConfirmPopUp: View{
    @Binding var isShowing: Bool
    var body: some View{
        ZStack{
            RoundedRectangle(cornerRadius: 20)
                .fill(Color("profile-orange"))
                .frame(width: 300, height: 400)
            
            VStack{
                        
                Button{
                    isShowing.toggle()
                }label:{
                    
                    ZStack{
                        Circle()
                            .fill(Color(.black))
                            .frame(width: 28, height: 28)
                            
                        Image("xMark")
                            .resizable()
                            .frame(width: 20, height: 20)
                    }
                        
                }
                    .padding(.leading, 240)
                
                Text("Create Event?")
                    .font(Font.custom("Viga-Regular", size: 28))
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                
                Text("      Are you sure you wish to \n create this event, and that all \n        the info is acurate?")
                    .font(Font.custom("Viga-Regular", size:16))
                    .foregroundColor(.lightGray)
                    .padding(.top, 5)
                
                Image("DefaultPFPL")
                    .resizable()
                    .frame(width:100, height: 100)
                
                Button {
                    print("saved")
                } label: {
                    ZStack{
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color("buttonColor"))
                            .frame(width: 140, height: 40)
                            .padding()
                        
                        Text("Create")
                            .font(Font.custom("Viga-Regular", size: 25))
                            .foregroundColor(.white)
                    }
                }
            }
        }
    }
}


struct TextBox: View
{
    @Binding var inputText: String
    var name: String
    var imageName: String
    var width: CGFloat
    var body: some View
    {
        VStack(alignment: .leading)
        {
            HStack
            {
                Image(imageName)
                    .renderingMode(.original)
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width * 0.080,height:UIScreen.main.bounds.height * 0.035)
                    .aspectRatio(contentMode: .fit)
                    .padding(.trailing, 4)
                
                Text(name)
                    .font(Font.custom("Viga-Regular", size: 26))
                    .foregroundStyle(Color("profile-orange"))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            TextField("", text: $inputText)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .font(.system(size: 16))
                .frame(width: width)
                .overlay(Rectangle().frame(height: 1).padding(.top, 20).padding(.leading,4))
                .onSubmit {
                    print("submitted")
                }
        }
    }
}

struct InputGrid: View {
    
    let Categories = [
        "General Body Meeting",
        "Cabinet Meeting",
        "Workshop",
        "Form/Survey"
    ]
    
    let ExpiresIn = [
        "1 hour",
        "2 hours",
        "3 hours",
        "4 hours"
    ]
    
    @ObservedObject var vm: EventCreatorViewModel
    
    var body: some View {
        VStack(spacing: UIScreen.main.bounds.height * 0.06){
            TextBox(inputText: $vm.eventTitle, name: "TITLE", imageName: "list", width : UIScreen.main.bounds.width * 0.7)
            TextBox(inputText: $vm.eventCode,  name: "CODE", imageName: "lock", width: UIScreen.main.bounds.width * 0.7)
            
            AdminDropDown(selection: $vm.eventCategory, options: Categories, width: UIScreen.main.bounds.width * 0.3, name: "CATEGORY", imageName: "list")
                .zIndex(999)
            
            TextBox(inputText: $vm.eventPoints, name: "POINTS", imageName: "list", width : UIScreen.main.bounds.width * 0.3)
            AdminDropDown(selection: $vm.eventDate, options: ExpiresIn, width: UIScreen.main.bounds.width * 0.3, name: "EXPIRES IN", imageName: "list")
                .zIndex(998)
        }
        .padding(.bottom, 10)
    }
}

struct AdminDropDown:View
{
    @Binding var selection: String
    
    let options: [String]
    let width: CGFloat
    
    @State private var isExpanded: Bool = false
    
    var name: String
    var imageName: String
    
    var body: some View {
        VStack
        {
            HStack
            {
                Image(imageName)
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: UIScreen.main.bounds.width * 0.085,height:UIScreen.main.bounds.height * 0.0375)
                    .padding(.trailing, 4)
                
                Text(name)
                    .font(Font.custom("Viga-Regular", size: 26))
                    .foregroundStyle(Color("profile-orange"))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding([.bottom, .top], 15)
            
            HStack
            {
                Text(selection)
                
                Spacer()
                
                Image(systemName: "chevron.down")
                    .rotationEffect(isExpanded ? .degrees(180) : .zero)
            }
            .frame(width: width, alignment: .leading)
            .overlay(Rectangle().frame(height: 1).padding(.top, 50))
            .padding(.trailing, UIScreen.main.bounds.width * 0.625)
            .onTapGesture {
                withAnimation(.easeInOut)
                {
                    isExpanded.toggle()
                }
            }
            
            if isExpanded
            {
                ScrollView
                {
                    ZStack{
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color("lightGray"))
                        VStack(alignment: .leading)
                        {
                            ForEach(options, id:\.self)
                            {
                            option in
                            Text(option)
                                .font(.system(size: 16))
                                .foregroundStyle(Color.black)
                                .padding(5)
                                .frame(width: width - 10, alignment: .leading)
                                .onTapGesture {
                                    selection = option
                                    isExpanded = false
                                }
                            }
                        }
                    .padding(.vertical, 10)
                    }
                    .zIndex(9999)
                }
                .frame(width: width, height: options.count > 4 ? 165 : 45 * CGFloat(options.count))
                .background(Color("lightGray"))
                .clipped(antialiased: false)
                .cornerRadius(10)
            }
        }
        .padding(.top, isExpanded ? options.count > 4 ? 175 : 45 * CGFloat(options.count) + 10 : 0)
        .padding(.bottom, 30)
        .frame(height: 35)
    }
}

#Preview {
   EventCreatorView()
}

