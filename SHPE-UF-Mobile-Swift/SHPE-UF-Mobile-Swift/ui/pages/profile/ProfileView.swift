//
//  ProfileView.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by victoria dib on 3/7/24.
//

import SwiftUI

struct ProfileView: View {
    @Environment(\.colorScheme) private var colorScheme
    
    @EnvironmentObject var manager: DataManager
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: []) private var user: FetchedResults<User>
    @StateObject var coreVM:CheckCoreViewModel = CheckCoreViewModel()
    
    @StateObject var vm:ProfileViewModel
    
    var body: some View {
        ScrollView 
        {
            VStack
            {
                ZStack
                {
                    let profilePFP = colorScheme == .dark ? "DefaultPFPD" : "DefaultPFPL"
                    
                    Image(colorScheme == .dark ? "Gator" : "Gator2")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 180, height: 200)
                        .offset(x:-UIScreen.main.bounds.width*0.42, y: colorScheme == .dark ? 40 : 30)
                        
                    
                    CurvedTopRectangle(cornerRadius: 10, curveHeight: 100)
                            .fill(Color("Profile-Background"))
                            .frame(width: UIScreen.main.bounds.width * 1.9, height: 150)
                            .padding(.top, 100)
                    
                    Image(profilePFP)
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width:130,height:130)
                        .padding(.top, 60)
                    
                    Text("\(vm.shpeito.firstName) \(vm.shpeito.lastName)")
                        .font(Font.custom("Viga-Regular", size: 24))
                        .offset(y:120)
                }
                .frame(maxWidth:.infinity)
                .background(Color("profile-orange"))
                
                    
                VStack
                {
                    
                    Button {
                        print("edit")
                    } label: {
                        HStack
                        {
                            Text("Edit Profile")
                                .foregroundStyle(Color.white)
                                .padding(10)
                            Image("pencil")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 20, height: 20)
                        }
                        .padding(.horizontal)
                        .background(Color("orangeButton"))
                        .cornerRadius(50)
                    }
                    .padding(.top, 10)

                    VStack(spacing: 2)
                    {
                        
                        Text("ACCOUNT INFO")
                            .font(Font.custom("Viga-Regular", size: 20))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(20)
                        
                        VStack(alignment: .leading)
                        {
                            HStack
                            {
                                Image("ProfileIcon")
                                    .renderingMode(.original)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width:25,height:25)
                                    .padding(.trailing, 10)
                                
                                Text("NAME")
                                    .font(Font.custom("Viga-Regular", size: 20))
                                    .foregroundStyle(Color("profile-orange"))
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text("\(vm.shpeito.firstName) \(vm.shpeito.lastName)")
                                .font(.system(size: 16))
                                .padding(.top, 5)
                        }
                        .padding(20)
                        .frame(maxWidth: .infinity)
                        .background(Color("whiteBox"))
                        
                        VStack(alignment: .leading)
                        {
                            HStack
                            {
                                Image("ProfileIcon")
                                    .renderingMode(.original)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width:25,height:25)
                                    .padding(.trailing, 10)
                                
                                Text("USERNAME")
                                    .font(Font.custom("Viga-Regular", size: 20))
                                    .foregroundStyle(Color("profile-orange"))
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text("\(vm.shpeito.username)")
                                .font(.system(size: 16))
                                .padding(.top, 5)
                        }
                        .padding(20)
                        .frame(maxWidth: .infinity)
                        .background(Color("whiteBox"))
                        
                        VStack(alignment: .leading)
                        {
                            HStack
                            {
                                Image("MessageIcon")
                                    .renderingMode(.original)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width:25,height:25)
                                    .padding(.trailing, 10)
                                
                                Text("EMAIL")
                                    .font(Font.custom("Viga-Regular", size: 20))
                                    .foregroundStyle(Color("profile-orange"))
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text("\(vm.shpeito.email)")
                                .font(.system(size: 16))
                                .padding(.top, 5)
                        }
                        .padding(20)
                        .frame(maxWidth: .infinity)
                        .background(Color("whiteBox"))
                        
                        VStack(alignment: .leading)
                        {
                            HStack
                            {
                                Image("GenderIcon")
                                    .renderingMode(.original)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width:25,height:25)
                                    .padding(.trailing, 10)
                                
                                Text("GENDER")
                                    .font(Font.custom("Viga-Regular", size: 20))
                                    .foregroundStyle(Color("profile-orange"))
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text("\(vm.shpeito.gender)")
                                .font(.system(size: 16))
                                .padding(.top, 5)
                        }
                        .padding(20)
                        .frame(maxWidth: .infinity)
                        .background(Color("whiteBox"))
                        
                        VStack(alignment: .leading)
                        {
                            HStack
                            {
                                Image("GlobeIcon")
                                    .renderingMode(.original)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width:25,height:25)
                                    .padding(.trailing, 10)
                                
                                Text("ETHNICITY")
                                    .font(Font.custom("Viga-Regular", size: 20))
                                    .foregroundStyle(Color("profile-orange"))
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text("\(vm.shpeito.ethnicity)")
                                .font(.system(size: 16))
                                .padding(.top, 5)
                        }
                        .padding(20)
                        .frame(maxWidth: .infinity)
                        .background(Color("whiteBox"))
                        
                        VStack(alignment: .leading)
                        {
                            HStack
                            {
                                Image("GlobeIcon")
                                    .renderingMode(.original)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width:25,height:25)
                                    .padding(.trailing, 10)
                                
                                Text("ORIGIN COUNTRY")
                                    .font(Font.custom("Viga-Regular", size: 20))
                                    .foregroundStyle(Color("profile-orange"))
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text("\(vm.shpeito.originCountry)")
                                .font(.system(size: 16))
                                .padding(.top, 5)
                        }
                        .padding(20)
                        .frame(maxWidth: .infinity)
                        .background(Color("whiteBox"))
                        
                        // Eductaion Info
                        Text("EDUCATION INFO")
                            .font(Font.custom("Viga-Regular", size: 20))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(20)
                            .padding(.top, 10)
                        
                        VStack(alignment: .leading)
                        {
                            HStack
                            {
                                Image("YearIcon")
                                    .renderingMode(.original)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width:25,height:25)
                                    .padding(.trailing, 10)
                                
                                Text("YEAR")
                                    .font(Font.custom("Viga-Regular", size: 20))
                                    .foregroundStyle(Color("profile-orange"))
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text("\(vm.shpeito.originCountry)")
                                .font(.system(size: 16))
                                .padding(.top, 5)
                        }
                        .padding(20)
                        .frame(maxWidth: .infinity)
                        .background(Color("whiteBox"))
                        
                        VStack(alignment: .leading)
                        {
                            HStack
                            {
                                Image("GradIcon")
                                    .renderingMode(.original)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width:25,height:25)
                                    .padding(.trailing, 10)
                                
                                Text("GRADUATION YEAR")
                                    .font(Font.custom("Viga-Regular", size: 20))
                                    .foregroundStyle(Color("profile-orange"))
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text("\(vm.shpeito.originCountry)")
                                .font(.system(size: 16))
                                .padding(.top, 5)
                        }
                        .padding(20)
                        .frame(maxWidth: .infinity)
                        .background(Color("whiteBox"))
                        
                        VStack(alignment: .leading)
                        {
                            HStack
                            {
                                Image("ClassesIcon")
                                    .renderingMode(.original)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width:25,height:25)
                                    .padding(.trailing, 10)
                                
                                Text("CLASSES")
                                    .font(Font.custom("Viga-Regular", size: 20))
                                    .foregroundStyle(Color("profile-orange"))
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text("\(vm.shpeito.originCountry)")
                                .font(.system(size: 16))
                                .padding(.top, 5)
                        }
                        .padding(20)
                        .frame(maxWidth: .infinity)
                        .background(Color("whiteBox"))
                        
                        VStack(alignment: .leading)
                        {
                            HStack
                            {
                                Image("InternshipsIcon")
                                    .renderingMode(.original)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width:25,height:25)
                                    .padding(.trailing, 10)
                                
                                Text("INTERNSHIPS")
                                    .font(Font.custom("Viga-Regular", size: 20))
                                    .foregroundStyle(Color("profile-orange"))
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text("\(vm.shpeito.originCountry)")
                                .font(.system(size: 16))
                                .padding(.top, 5)
                        }
                        .padding(20)
                        .frame(maxWidth: .infinity)
                        .background(Color("whiteBox"))
                        
                        VStack(alignment: .leading)
                        {
                            HStack
                            {
                                Image("LinksIcon")
                                    .renderingMode(.original)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width:25,height:25)
                                    .padding(.trailing, 10)
                                
                                Text("LINKS")
                                    .font(Font.custom("Viga-Regular", size: 20))
                                    .foregroundStyle(Color("profile-orange"))
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text("\(vm.shpeito.originCountry)")
                                .font(.system(size: 16))
                                .padding(.top, 5)
                        }
                        .padding(20)
                        .frame(maxWidth: .infinity)
                        .background(Color("whiteBox"))
                        
                        // Appearance
                        Text("APPEARANCE")
                            .font(Font.custom("Viga-Regular", size: 20))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(20)
                            .padding(.top, 10)
                        
                        HStack
                        {
                            Image("LightIcon")
                                .renderingMode(.original)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width:25,height:25)
                                .padding(.trailing, 10)
                                .padding(20)
                            
                            Text("Light Mode")
                                .font(Font.custom("Viga-Regular", size: 20))
                                .foregroundStyle(Color("profile-orange"))
                            
                            Spacer()
                            
                            Circle()
                                .frame(width: 30)
                                .foregroundStyle(Color("whiteBox"))
                                .overlay(
                                    Circle()
                                        .stroke(Color.gray, lineWidth: 2) // Adjust border color and width as needed
                                )
                                .padding(.trailing, 20)
                        }
                        .frame(maxWidth: .infinity)
                        .background(Color("whiteBox"))
                        
                        HStack
                        {
                            Image("DarkModeIcon")
                                .renderingMode(.original)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width:25,height:25)
                                .padding(.trailing, 10)
                                .padding(20)
                            
                            Text("Dark Mode")
                                .font(Font.custom("Viga-Regular", size: 20))
                                .foregroundStyle(Color("profile-orange"))
                            
                            Spacer()
                            
                            Circle()
                                .frame(width: 30)
                                .foregroundStyle(Color("whiteBox"))
                                .overlay(
                                    Circle()
                                        .stroke(Color.gray, lineWidth: 2) // Adjust border color and width as needed
                                )
                                .padding(.trailing, 20)
                        }
                        .frame(maxWidth: .infinity)
                        .background(Color("whiteBox"))
                        
                        Button {
                            if !user.isEmpty
                            {
                                coreVM.deleteUserItemToCore(viewContext: viewContext, user: user[0])
                                AppViewModel.appVM.setPageIndex(index: 0)
                            }
                            else
                            {
                                print("Expected User in Core")
                            }
                        } label: {
                            HStack
                            {
                                Text("Sign Out")
                                    .font(Font.custom("Viga-Regular", size: 20))
                                    .foregroundStyle(Color.white)
                                    .padding(10)
                                Image("signOut")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 20, height: 20)
                            }
                            .padding(.horizontal)
                            .background(Color.red)
                            .cornerRadius(50)
                        }
                        .padding(.vertical, 30)
                    }
                    .frame(width: UIScreen.main.bounds.width)
                    
                }
                
            }
            .background(Color("Profile-Background"))
        }
        .ignoresSafeArea()
        .background(Color("profile-orange"))
    }
}

struct CurvedTopRectangle: Shape {
    let cornerRadius: CGFloat
    let curveHeight: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let width = rect.width
        let height = rect.height
        
        // Start drawing path from top-left corner
        path.move(to: CGPoint(x: 0, y: curveHeight))
        
        // Draw straight line to top-center
//        path.addLine(to: CGPoint(x: width / 2, y: 0))
        
        // Draw quadratic curve to top-right corner
        path.addQuadCurve(to: CGPoint(x: width, y: curveHeight), control: CGPoint(x: width / 2, y: 0))
        
        // Draw straight line to bottom-right corner
        path.addLine(to: CGPoint(x: width, y: height))
        
        // Draw bottom-right corner
        path.addLine(to: CGPoint(x: 0, y: height))
        
        // Close the path
        path.closeSubpath()
        
        return path
    }
}

#Preview {
    ProfileView(vm:ProfileViewModel(shpeito: SHPEito(
            username: "dvera0322",
            password: "",
            remember: "true",
            photo: "",
            firstName: "David",
            lastName: "Denis",
            year: "2",
            major: "Computer Science",
            id: "642f7f80e8839f0014e8be9b",
            token: "",
            confirmed: true,
            updatedAt: "",
            createdAt: "",
            email: "denisdavid@ufl.edu",
            fallPoints: 20,
            summerPoints: 17,
            springPoints: 30,
            points: 67,
            fallPercentile: 93,
            springPercentile: 98,
            summerPercentile: 78)
    ))
}
    

