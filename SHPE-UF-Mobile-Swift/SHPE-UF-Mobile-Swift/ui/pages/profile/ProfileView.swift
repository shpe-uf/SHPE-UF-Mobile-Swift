//
//  ProfileView.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by victoria dib on 3/7/24.
//

import SwiftUI

struct ProfileView: View 
{
    @Environment(\.colorScheme) private var colorScheme
    
    @EnvironmentObject var manager: DataManager
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: []) private var user: FetchedResults<User>
    @FetchRequest(sortDescriptors: []) private var coreEvents: FetchedResults<CalendarEvent>
    @FetchRequest(sortDescriptors: []) private var userEvents: FetchedResults<CoreUserEvent>
    @StateObject var coreVM:CheckCoreViewModel = CheckCoreViewModel()
    @StateObject var appVM:AppViewModel = AppViewModel.appVM
    
    @StateObject var vm:ProfileViewModel
    
    @State var validUsername:Bool = true
    @State var clickedDeleteAccount:Bool = false
    
    @State var loadingDelete:Bool = false
    @State var errorDeleting:Bool = false
    
    var body: some View {
        ZStack
        {
            VStack
            {
                ZStack
                {
                    let profilePFP = appVM.darkMode ? "DefaultPFPD" : "DefaultPFPL"
                    
                    Image(appVM.darkMode ? "Gator" : "Gator2")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 180, height: 200)
                        .offset(x:-UIScreen.main.bounds.width*0.42, y: appVM.darkMode ? 40 : 30)
                    
                    
                    CurvedTopRectangle(cornerRadius: 10, curveHeight: 100)
                        .fill(Color("Profile-Background"))
                        .frame(width: UIScreen.main.bounds.width * 1.9, height: 150)
                        .padding(.top, 100)
                    
                    if let selectedImage = vm.selectedImage,
                       vm.isEditing
                    {
                        Image(uiImage: selectedImage)
                            .renderingMode(.original)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width:130,height:130)
                            .cornerRadius(100)
                            .overlay(
                                RoundedRectangle(cornerRadius: 100)
                                    .stroke( Color("Profile-Background") , lineWidth: 5)
                            )
                            .padding(.top, 60)
                        
                    }
                    else if let profileImage = vm.shpeito.profileImage
                    {
                        Image(uiImage: profileImage)
                            .renderingMode(.original)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width:130,height:130)
                            .cornerRadius(100)
                            .overlay(
                                RoundedRectangle(cornerRadius: 100)
                                    .stroke( Color("Profile-Background") , lineWidth: 5)
                            )
                            .padding(.top, 60)
                    }
                    else
                    {
                        Image(profilePFP)
                            .renderingMode(.original)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width:130,height:130)
                            .padding(.top, 60)
                    }
                    
                    
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
                                vm.showImagePicker.toggle()
                            }
                            .sheet(isPresented: $vm.showImagePicker, onDismiss: {})
                        {
                            ImagePicker(selectedImage: $vm.selectedImage, sourceType: .photoLibrary)
                                .ignoresSafeArea()
                        }
                    }
                    
                    if vm.isEditing
                    {
                        TextField(vm.newName, text: $vm.newName)
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.never)
                            .multilineTextAlignment(.center)
                            .font(Font.custom("Viga-Regular", size: 24))
                            .overlay(Rectangle().frame(height: 1).padding(.top, 35))
                            .offset(y:120)
                            .frame(width: CGFloat(vm.newName.count) * 15)
                            .onSubmit {
                                vm.validateName()
                            }
                        
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
                        HStack(spacing: 10)
                        {
                            if !vm.isEditing
                            {
                                Button
                                {
                                    vm.isEditing = true
                                }
                                label:
                                {
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
                            }

                            // ✅ Show Admin Panel button if user has admin permissions
                            if vm.shpeito.permission.lowercased().contains("admin")
                            {
                                Button
                                {
                                    print("Navigating to Admin Panel") // Replace with actual navigation logic
                                }
                                label:
                                {
                                    HStack
                                    {
                                        Text("Admin Panel")
                                            .foregroundStyle(Color.white)
                                            .padding(10)

                                        Image(systemName: "shield.fill") // Admin icon
                                            .resizable()
                                            .frame(width: 20, height: 20)
                                    }
                                    .padding(.horizontal)
                                    .background(Color.red)
                                    .cornerRadius(50)
                                }
                            }
                        }
                        .padding(.top, 10)
                        
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
                                    TextField(vm.newName, text: $vm.newName)
                                        .autocorrectionDisabled()
                                        .textInputAutocapitalization(.never)
                                        .font(.system(size: 16))
                                        .padding(.top, 5)
                                        .frame(width: 270)
                                        .overlay(Rectangle().frame(height: 1).padding(.top, 35))
                                        .onSubmit {
                                            vm.validateName()
                                        }
                                    
                                    if vm.invalidFirstName
                                    {
                                        Text("First name must be at least 1 character, no special characters or numbers")
                                            .font(.caption)
                                            .foregroundColor(.red)
                                            .padding(.top, 5)
                                    }
                                    
                                    if vm.invalidLastName
                                    {
                                        Text("Last name must be at least 1 character, no special characters or numbers")
                                            .font(.caption)
                                            .foregroundColor(.red)
                                            .padding(.top, 5)
                                    }
                                    
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
                                
                                if vm.isEditing
                                {
                                    DropDown(vm: vm, change: $vm.newGender, options: vm.genderoptions, width: 120)
                                }
                                else
                                {
                                    Text("\(vm.shpeito.gender)")
                                        .font(.system(size: 16))
                                        .padding(.top, 5)
                                }
                                
                            }
                            .padding(20)
                            .frame(maxWidth: .infinity)
                            .background(Color("whiteBox"))
                            .zIndex(6)
                            
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
                                
                                if vm.isEditing
                                {
                                    DropDown(vm: vm, change: $vm.newEthnicity, options: vm.ethnicityoptions, width: 240)
                                }
                                else
                                {
                                    Text("\(vm.shpeito.ethnicity)")
                                        .font(.system(size: 16))
                                        .padding(.top, 5)
                                }
                            }
                            .padding(20)
                            .frame(maxWidth: .infinity)
                            .background(Color("whiteBox"))
                            .zIndex(5)
                            
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
                                
                                if vm.isEditing
                                {
                                    DropDown(vm: vm, change: $vm.newOriginCountry, options: vm.originoptions, width: 240)
                                }
                                else
                                {
                                    Text("\(vm.shpeito.originCountry)")
                                        .font(.system(size: 16))
                                        .padding(.top, 5)
                                }
                            }
                            .padding(20)
                            .frame(maxWidth: .infinity)
                            .background(Color("whiteBox"))
                            .zIndex(4)
                            
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
                                    Image("GradIcon")
                                        .renderingMode(.original)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width:25,height:25)
                                        .padding(.trailing, 10)
                                    
                                    Text("MAJOR")
                                        .font(Font.custom("Viga-Regular", size: 20))
                                        .foregroundStyle(Color("profile-orange"))
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                
                                if vm.isEditing
                                {
                                    DropDown(vm: vm, change: $vm.newMajor, options: vm.majorOptions, width: 200)
                                }
                                else
                                {
                                    Text("\(vm.shpeito.major)")
                                        .font(.system(size: 16))
                                        .padding(.top, 5)
                                }
                            }
                            .padding(20)
                            .frame(maxWidth: .infinity)
                            .background(Color("whiteBox"))
                            .zIndex(3)
                            
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
                                
                                if vm.isEditing
                                {
                                    DropDown(vm: vm, change: $vm.newYear, options: vm.yearoptions, width: 200)
                                }
                                else
                                {
                                    Text("\(vm.shpeito.year)")
                                        .font(.system(size: 16))
                                        .padding(.top, 5)
                                }
                            }
                            .padding(20)
                            .frame(maxWidth: .infinity)
                            .background(Color("whiteBox"))
                            .zIndex(2)
                            
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
                                
                                if vm.isEditing
                                {
                                    DropDown(vm: vm, change: $vm.newGradYear, options: vm.gradoptions, width: 100)
                                }
                                else
                                {
                                    Text("\(vm.shpeito.graduationYear)")
                                        .font(.system(size: 16))
                                        .padding(.top, 5)
                                }
                            }
                            .padding(20)
                            .frame(maxWidth: .infinity)
                            .background(Color("whiteBox"))
                            .zIndex(1)
                            
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
                                
                                if vm.isEditing
                                {
                                    MultipleLabels(placeholder: "Add your classes here", change: $vm.newClasses, validationFunction: {_ in true})
                                        .frame(height: {
                                            var count:CGFloat = 0
                                            var padding:CGFloat = 12.5*CGFloat(vm.newClasses.count)
                                            for item in vm.newClasses
                                            {
                                                count += CGFloat(item.count)
                                            }
                                            return ceil( (count * 2.5 + padding) / 100.0 ) * 50 + 70
                                        }())
                                }
                                else
                                {
                                    VStack
                                    {
                                        ForEach(vm.shpeito.classes, id:\.self)
                                        {
                                            classStr in
                                            
                                            Text(classStr)
                                                .font(.system(size: 16))
                                                .padding(.top, 5)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                            
                                        }
                                    }
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
                                
                                if vm.isEditing
                                {
                                    MultipleLabels(placeholder: "Add your internships here", change: $vm.newInternships, validationFunction: {_ in true})
                                        .frame(height: {
                                            var count:CGFloat = 0
                                            var padding:CGFloat = 12.5*CGFloat(vm.newClasses.count)
                                            for item in vm.newInternships
                                            {
                                                count += CGFloat(item.count)
                                            }
                                            return ceil( (count*2.5 + padding) / 100.0 ) * 50 + 70
                                        }())
                                }
                                else
                                {
                                    VStack
                                    {
                                        ForEach(vm.shpeito.internships, id:\.self)
                                        {
                                            internship in
                                            
                                            Text(internship)
                                                .font(.system(size: 16))
                                                .padding(.top, 5)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                            
                                        }
                                    }
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
                                
                                if vm.isEditing
                                {
                                    MultipleLabels(placeholder: "Add your links here", change: $vm.newLinks, validationFunction: {urlString in
                                        if let url = URL(string: urlString) {
                                            // URL initialization succeeded, so the string is a valid URL
                                            return UIApplication.shared.canOpenURL(url)
                                        }
                                        return false
                                    })
                                    .frame(height: {
                                        var count:CGFloat = 0
                                        var padding:CGFloat = 12.5*CGFloat(vm.newClasses.count)
                                        for item in vm.newLinks
                                        {
                                            count += CGFloat(item.count)
                                        }
                                        return ceil( (count*2.5 + padding) / 100.0 ) * 50 + 70
                                    }())
                                }
                                else
                                {
                                    VStack
                                    {
                                        ForEach(vm.shpeito.links, id:\.self)
                                        {
                                            link in
                                            
                                            Text(link.absoluteString)
                                                .font(.system(size: 16))
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .padding(.top, 5)
                                                .onTapGesture {
                                                    UIApplication.shared.open(link)
                                                }
                                            
                                        }
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
                                
                                if !appVM.darkMode
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
                            .onTapGesture {
                                appVM.setDarkMode(bool: false, user: user, viewContext: viewContext)
                            }
                            
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
                                
                                if appVM.darkMode
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
                            .onTapGesture {
                                appVM.setDarkMode(bool: true, user: user, viewContext: viewContext)
                            }
                            
                            if !vm.isEditing
                            {
                                Button {
                                    if !user.isEmpty
                                    {
                                        NotificationViewModel.instance.clearPendingNotifications(fetchedEvents: coreEvents, viewContext: viewContext)
                                        CoreFunctions().clearCore(events: coreEvents, users: user, userEvents: userEvents, viewContext: viewContext)
                                        AppViewModel.appVM.setPageIndex(index: 3)
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
                                .padding(.vertical, 15)
                                
                                HStack
                                {
                                    Text("Delete Account")
                                        .font(Font.custom("Viga-Regular", size: 20))
                                        .padding(10)
                                }
                                .padding(.horizontal)
                                .cornerRadius(50)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 50)
                                        .stroke(lineWidth: 3)
                                        .foregroundStyle(Color.gray)
                                }
                                .onTapGesture {
                                    print("Clicked Delete Account")
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        clickedDeleteAccount = true
                                    }
                                }
                            }
                            else
                            {
                                HStack
                                {
                                    Button {
                                        vm.saveEditsToProfile(user: user, viewContext: viewContext)
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
                                        vm.clearFields()
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
                        .padding(.bottom, 100)
                        
                    }
                }
                .padding(.top, vm.isEditing ? 20 : 0)
            }
            .ignoresSafeArea()
            .background(Color("Profile-Background"))
            .preferredColorScheme(appVM.darkMode ? .dark : .light)
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
            
            if clickedDeleteAccount
            {
                VisualEffectBlur(blurStyle: .systemUltraThinMaterial)
                                    .edgesIgnoringSafeArea(.all)
                
                VStack
                {
                    HStack()
                    {
                        Spacer()
                        Image("x_mark")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .padding(5)
                            .background(Color.black.opacity(0.1))
                            .cornerRadius(20)
                            .onTapGesture {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    errorDeleting = false
                                    clickedDeleteAccount = false
                                    loadingDelete = false
                                }
                            }
                    }
                    
                    Spacer()
                    
                    Text("Delete Account?")
                        .foregroundStyle(Color.white)
                        .font(Font.custom("Viga-Regular", size: 24))
                        .padding(.bottom, 10)
                    
                    Text("Deleting your account will remove all your personal data permanently.")
                        .multilineTextAlignment(.center)
                        .foregroundStyle(Color.white)
                        .font(Font.custom("", size: 16))
                    
                    let profilePFP = appVM.darkMode ? "DefaultPFPD" : "DefaultPFPL"
                    
                    if let profileImage = vm.shpeito.profileImage
                    {
                        Image(uiImage: profileImage)
                            .renderingMode(.original)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width:130,height:130)
                            .cornerRadius(100)
                            .overlay(
                                RoundedRectangle(cornerRadius: 100)
                                    .stroke( Color("Profile-Background") , lineWidth: 5)
                            )
                            .padding(.vertical, 20)
                    }
                    else
                    {
                        Image(profilePFP)
                            .renderingMode(.original)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width:130,height:130)
                            .padding(.vertical, 20)
                    }
                    
                    Button {
                        loadingDelete = true
                        vm.deleteAccount { data in
                            withAnimation(.easeInOut(duration: 0.2))
                            {
                                if (data["error"] != nil)
                                {
                                    errorDeleting = true
                                }
                                else
                                {
                                    errorDeleting = false
                                    NotificationViewModel.instance.clearPendingNotifications(fetchedEvents: coreEvents, viewContext: viewContext)
                                    CoreFunctions().clearCore(events: coreEvents, users: user, userEvents: userEvents, viewContext: viewContext)
                                    appVM.toastMessage = "Account deleted successfully"
                                    appVM.showToast = true
                                    appVM.shpeito = SHPEito()
                                    appVM.setPageIndex(index: 3)
                                }
                                loadingDelete = false
                            }
                            
                        }
                    } label: {
                        HStack
                        {
                            Text("Delete")
                                .foregroundStyle(Color.white)
                                .font(Font.custom("Viga-Regular", size: 24))
                                .padding(.trailing, 5)
                            
                            if loadingDelete
                            {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .scaleEffect(1) // Adjust size
                                    .padding(5)
                            }
                        }
                        .padding(.vertical, 5)
                        .padding(.horizontal, 30)
                        .background(Color.darkdarkBlue)
                        .cornerRadius(12)
                    }
                    .padding(.bottom, errorDeleting ? 10 : 20)
                    
                    if errorDeleting
                    {
                        Text("Could not delete account at the moment. Try again later...")
                            .multilineTextAlignment(.center)
                            .foregroundStyle(Color.white)
                            .font(Font.custom("", size: 16))
                            .padding(.bottom, 20)
                    }
                }
                .padding()
                .frame(width: 309, height: errorDeleting ? 470 : 406, alignment: .center)
                .background(Color.profileOrange)
                .cornerRadius(30)
                .zIndex(999)
            }
        }
    }
}

struct VisualEffectBlur: UIViewRepresentable {
    var blurStyle: UIBlurEffect.Style
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: blurStyle))
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: blurStyle)
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

struct DropDown:View
{
    @StateObject var vm: ProfileViewModel
    @Binding var change: String
    
    let options: [String]
    let width: CGFloat
    @State private var toggle:Bool = false
    
    var body: some View {
        VStack
        {
            HStack
            {
                Text(change)
                
                Spacer()
                
                Image(systemName: "chevron.down")
                    .rotationEffect(vm.dropdownPressed == change ? .degrees(180) : .zero)
            }
            .frame(width: width)
            .overlay(Rectangle().frame(height: 1).padding(.top, 35))
            .onTapGesture {
                withAnimation(.easeInOut)
                {
                    vm.dropdownPressed = vm.dropdownPressed != change ? change : ""
                }
            }
            
            if vm.dropdownPressed == change
            {
                ScrollView
                {
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
                                    change = option
                                }
                        }
                    }
                    .padding(.vertical, 10)
                }
                .frame(width: width, height: options.count > 4 ? 165 : 45 * CGFloat(options.count))
                .background(Color("lightGray"))
                .clipped(antialiased: false)
                .cornerRadius(10)
            }
        }
        .padding(.top, vm.dropdownPressed == change ? options.count > 4 ? 175 : 45 * CGFloat(options.count) + 10 : 0)
        .frame(height: 35)
    }
}

typealias ValidationFunction = (String) -> Bool

struct MultipleLabels:View {
    let placeholder:String
    @Binding var change: [String]
    let validationFunction: ValidationFunction
    
    @State private var input:String = ""
    @State private var invalidInputMessage:String = ""
    
    
    var body: some View {
        VStack
        {
            HStack
            {
                TextField(placeholder, text: $input)
                    .limitInputLength(value: $input, length: 100)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(TextInputAutocapitalization(.none))
                    .font(.system(size: 16))
                    .padding(.top, 5)
                    .frame(width: 270)
                    .overlay(Rectangle().frame(height: 1).padding(.top, 35))
                
                Spacer()
                
                Button {
                    if change.contains(input)
                    {
                        invalidInputMessage = "Input already exists"
                    }
                    else if validationFunction(input)
                    {
                        invalidInputMessage = ""
                        change.append(input)
                    }
                    else
                    {
                        invalidInputMessage = "Invalid Input"
                    }
                    input = ""
                } label: {
                    Image("addButton")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 30, height: 30)
                        .opacity(input.isEmpty ? 0.5 : 1)
                }
                .disabled(input.isEmpty)
                
            }
            
            Text(invalidInputMessage)
                .foregroundStyle(Color.red)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            GeometryReader { geometry in
                self.generateContent(in: geometry, list: change)
            }
                        
        }
        .padding(.vertical, 20)
    }
    
    private func generateContent(in g: GeometryProxy, list:[String]) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero

        return 
            VStack
            {
                ZStack(alignment: .topLeading)
                {
                    ForEach(list, id: \.self)
                    { item in
                        self.item(for: item)
                            .padding([.horizontal, .vertical], 4)
                            .alignmentGuide(.leading, computeValue: { d in
                                if (abs(width - d.width) > g.size.width)
                                {
                                    width = 0
                                    height -= d.height
                                }
                                let result = width
                                if item == list.last! {
                                    width = 0 //last item
                                } else {
                                    width -= d.width
                                }
                                return result
                            })
                            .alignmentGuide(.top, computeValue: {d in
                                let result = height
                                if item == list.last! {
                                    height = 0 // last item
                                }
                                return result
                            })
                        }
                    }
            }
            .padding(.top, 20)
        }
        
        func item(for text: String) -> some View {
            HStack
            {
                Text(text)
                    .font(Font.custom("Manrope-Light", size: 16))
                    .padding(.all, 5)
                    .padding(.leading, 5)
                    .font(.body)
                    
                Image("xMark")
                    .resizable()
                    .frame(width: 16, height: 16)
                    .padding(.all, 5)
                    .onTapGesture {
                        var index = 0
                        for interest in change
                        {
                           if text == interest
                            {
                               change.remove(at: index)
                            }
                            index += 1
                        }
                    }
                
            }
            .background(Color("buttonColor"))
            .foregroundColor(Color.white)
            .cornerRadius(20)
        }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    var sourceType: UIImagePickerController.SourceType
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        
        init(parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image.resize()
            }
            
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

#Preview {
    ProfileView(vm:ProfileViewModel(shpeito: SHPEito()
    ))
}
    

