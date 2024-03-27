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
                
                if vm.isEditing
                {
                    Image("imageIcon")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width:30, height: 30)
                        .padding(10)
                        .background(Color("gray"))
                        .cornerRadius(50)
                        .overlay(
                            RoundedRectangle(cornerRadius: 50)
                                .stroke( Color("profile-orange") , lineWidth: 5)
                        )
                        .offset(x:45, y:-10)
                        .onTapGesture {
                            print("upload photo")
                        }
                }
                
                if vm.isEditing
                {
                    TextField(vm.newName, text: $vm.newName)
                        .multilineTextAlignment(.center)
                        .font(Font.custom("Viga-Regular", size: 24))
                        .overlay(Rectangle().frame(height: 1).padding(.top, 35))
                        .offset(y:120)
                        .frame(width: CGFloat(vm.newName.count) * 12)
                        
                }
                else
                {
                    Text("\(vm.shpeito.name)")
                        .font(Font.custom("Viga-Regular", size: 24))
                        .offset(y:120)
                }
            }
            .frame(maxWidth:.infinity)
            .background(Color("profile-orange"))
            
            ScrollView
            {
                VStack
                {
                    if !vm.isEditing
                    {
                        Button {
                            vm.isEditing = true
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
                    }

                    VStack(spacing: 2)
                    {
                        
                        Text("ACCOUNT INFO")
                            .font(Font.custom("Viga-Regular", size: 20))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(20)
                            .padding(.top, vm.isEditing ? 30 : 0)
                        
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
                            
                            if vm.isEditing
                            {
                                TextField("vm.shpeito.name", text: $vm.shpeito.name)
                                    .font(.system(size: 16))
                                    .padding(.top, 5)
                                    .frame(width: 270)
                                    .overlay(Rectangle().frame(height: 1).padding(.top, 35))
                                    
                            }
                            else
                            {
                                Text("\(vm.shpeito.name)")
                                    .font(.system(size: 16))
                                    .padding(.top, 5)
                            }
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
                            
                            
                            if vm.isEditing
                            {
                                TextField("vm.shpeito.name", text: $vm.shpeito.username)
                                    .font(.system(size: 16))
                                    .padding(.top, 5)
                                    .frame(width: 270)
                                    .overlay(Rectangle().frame(height: 1).padding(.top, 35))
                                    
                            }
                            else
                            {
                                Text("\(vm.shpeito.username)")
                                    .font(.system(size: 16))
                                    .padding(.top, 5)
                            }
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
                            
                            Text("\(vm.shpeito.year)")
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
                            
                            Text("\(vm.shpeito.graduationYear)")
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
                            
                            ForEach(vm.shpeito.classes, id:\.self)
                            {
                                classStr in
                                
                                Text(classStr)
                                    .font(.system(size: 16))
                                    .padding(.top, 5)
                                
                            }
                            
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
                            
                            ForEach(vm.shpeito.internships, id:\.self)
                            {
                                internship in
                                
                                Text(internship)
                                    .font(.system(size: 16))
                                    .padding(.top, 5)
                                
                            }
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
                            
                            ForEach(vm.shpeito.links, id:\.self)
                            {
                                link in
                                
                                Text(link.absoluteString)
                                    .font(.system(size: 16))
                                    .padding(.top, 5)
                                    .onTapGesture {
                                        UIApplication.shared.open(link)
                                    }
                                
                            }
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
                            
                            if colorScheme != .dark
                            {
                                Image("checkmark")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 40, height: 40)
                                    .padding(.trailing, 16)
                            }
                            else
                            {
                                Circle()
                                    .frame(width: 30)
                                    .foregroundStyle(Color("whiteBox"))
                                    .overlay(
                                        Circle()
                                            .stroke(Color.gray, lineWidth: 2) // Adjust border color and width as needed
                                    )
                                    .padding(.trailing, 20)
                            }
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
                            
                            if colorScheme == .dark
                            {
                                Image("checkmark")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 40, height: 40)
                                    .padding(.trailing, 16)
                            }
                            else
                            {
                                Circle()
                                    .frame(width: 30)
                                    .foregroundStyle(Color("whiteBox"))
                                    .overlay(
                                        Circle()
                                            .stroke(Color.gray, lineWidth: 2) // Adjust border color and width as needed
                                    )
                                    .padding(.trailing, 20)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .background(Color("whiteBox"))
                        
                        if !vm.isEditing
                        {
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
                        else
                        {
                            HStack
                            {
                                Button {
                                    print("save changes")
                                    vm.isEditing = false
                                } label: {
                                    Text("Save")
                                        .foregroundStyle(Color.white)
                                        .font(Font.custom("Viga-Regular", size: 20))
                                        .padding(10)
                                        .frame(width: 150)
                                        .background(Color("orangeButton"))
                                        .cornerRadius(50)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 50)
                                                .stroke( Color.white , lineWidth: 1)
                                        )
                                }
                                .padding(.trailing, 20)
                                
                                Button {
                                    print("cancel changes")
                                    vm.isEditing = false
                                } label: {
                                    Text("Cancel")
                                        .foregroundStyle(Color.white)
                                        .font(Font.custom("Viga-Regular", size: 20))
                                        .padding(10)
                                        .frame(width: 150)
                                        .background(Color("orangeButton"))
                                        .cornerRadius(50)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 50)
                                                .stroke( Color.white , lineWidth: 1)
                                        )
                                }
                            }
                            .padding(.vertical, 30)
                        }
                        
                    }
                    .frame(width: UIScreen.main.bounds.width)
                    
                }
            }
            .padding(.top, vm.isEditing ? 20 : 0)
        }
        .ignoresSafeArea()
        .background(Color("Profile-Background"))
        
        
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
            year: "Sophmore",
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
    

