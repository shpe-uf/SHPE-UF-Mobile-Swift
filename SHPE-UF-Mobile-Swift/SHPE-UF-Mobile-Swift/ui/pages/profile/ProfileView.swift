//
//  ProfileView.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by victoria dib on 3/7/24.
//

import SwiftUI

struct ProfileView: View {
        @State private var isEditing = false
        @State private var name = "Daniel Dovale"
        @State private var username = "d.dovale"
        @State private var email = "ddovale2004@example.com"
    @State private var gender = 0
        let genderoptions = ["Male", "Female", "Option 3"]
    @State private var ehtnicity = 0
        let ethnicityoptions = ["Hispanic", "African American", "White", "Asian", "Native American/Alaskan Native", "Native Hawaiian/Pacific Islander", "Middle Eastern/North African", "Multiethnic"]
    @State private var origin = 0
        let originoptions = ["x", "x", "z"]
    @State private var year = 0
        let yearoptions = ["Freshman", "Sophomore", "Junior", "Senior", "5th Year"]
    @State private var grad = 0
        let gradoptions = ["2024", "2025", "2026", "2027", "2028"]
    
    @State private var enteredClasses: String = ""
    @State private var selectedClasses: [String] = []
    
    @State private var enteredInternships: String = ""
    @State private var selectedInternships: [String] = []

    @Environment(\.colorScheme) private var colorScheme
    var body: some View {
        
        
        ScrollView {
            VStack {
                ZStack {
                    let backgroundcircle = colorScheme == .dark ? "Background CircleD" : "Background CircleL"
                    
                    let topbackground = colorScheme == .dark ? "TopBackgroundD" : "TopBackgroundL"
                    
                    let profilePFP = colorScheme == .dark ? "DefaultPFPD" : "DefaultPFPL"
                    
                    Color("Profile-Background")
                        .edgesIgnoringSafeArea(.all)
                    
                    Image(topbackground)
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width:420,height:550)
                        .padding(.top, -1200)
                        .padding(.leading,30)
                    //.padding(.leading,0.5)
                    //Background circle dimensions:
                    Image(backgroundcircle)
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width:1900,height:520)
                        .padding(.top, -880)
                        .padding(.leading,0.5)
                    
                    Image(profilePFP)
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width:130,height:380)
                        .padding(.top, -1060)
                        .padding(.leading,0.5)
                    
                    VStack{
                        let ButtonEdit = colorScheme == .dark ? "ButtonEditD" : "ButtonEditDL"
                        // Button represented by an image
                        Image(ButtonEdit) // Replace "yourImageName" with the name of your image asset
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 170, height: 200)
                            .padding(.top, 120)
                            .padding(.leading,0.5)// Adjust size as needed
                        
                        let AccountInfo = colorScheme == .dark ? "AccountInfoD" : "AccountInfoL"
                        // Button represented by an image
                        Image(AccountInfo) // Replace "yourImageName" with the name of your image asset
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 140, height: 200)
                            .padding(.top, -150)
                            .padding(.leading,-170)// Adjust size as needed
                        
                        VStack(spacing: 2){
                            let Rect = colorScheme == .dark ? "RecD" : "RecL"
                            // Button represented by an image
                            Image(Rect) // Replace "yourImageName" with the name of your image asset
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 450, height: 140)
                                .padding(.top, -95)
                                .padding(.leading,0)// Adjust size as needed
                            HStack{
                                Image("ProfileIcon")
                                    .renderingMode(.original)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width:25,height:100)
                                    .padding(.top, -150)
                                    .padding(.leading,-155)
                                
                                Image("NameIcon")
                                    .renderingMode(.original)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width:57,height:100)
                                    .padding(.top, -150)
                                    .padding(.leading,-120)
                                
                                Text("\(name)")
                                    .font(.system(size: 15))
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width:190,height:100)
                                    .padding(.top, -100)
                                    .padding(.leading,-210)
                                
                            }
                            
                            
                            Image(Rect)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 450, height: 140)
                                .padding(.top, -35)
                                .padding(.leading,0)// Adjust size as needed
                            
                            HStack{
                                Image("ProfileIcon")
                                    .renderingMode(.original)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width:25,height:100)
                                    .padding(.top, -150)
                                    .padding(.leading,-155)
                                
                                Image("UsernameIcon")
                                    .renderingMode(.original)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width:110,height:100)
                                    .padding(.top, -150)
                                    .padding(.leading,-120)
                                
                                Text("\(username)")
                                    .font(.system(size: 15))
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width:190,height:100)
                                    .padding(.top, -105)
                                    .padding(.leading,-230)
                            }
                            
                            Image(Rect) // Replace "yourImageName" with the name of your image asset
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 450, height: 140)
                                .padding(.top, -35)
                                .padding(.leading,0)// Adjust size as needed
                            
                            HStack{
                                Image("MessageIcon")
                                    .renderingMode(.original)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width:25,height:100)
                                    .padding(.top, -150)
                                    .padding(.leading,-125)
                                
                                Image("EmailIcon")
                                    .renderingMode(.original)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width:60,height:100)
                                    .padding(.top, -150)
                                    .padding(.leading,-90)
                                
                                Text("\(email)")
                                    .font(.system(size: 15))
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width:200,height:100)
                                    .padding(.top, -105)
                                    .padding(.leading,-140)
                            }
                            
                            Image(Rect) // Replace "yourImageName" with the name of your image asset
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 450, height: 140)
                                .padding(.top, -35)
                                .padding(.leading,0)// Adjust size as needed
                            
                            HStack{
                                Image("GenderIcon")
                                    .renderingMode(.original)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width:33,height:100)
                                    .padding(.top, -150)
                                    .padding(.leading,-160)
                                
                                Image("GenderWord")
                                    .renderingMode(.original)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width:80,height:100)
                                    .padding(.top, -150)
                                    .padding(.leading,-120)
                                
                                //add drop down option to display gender
                            }
                            
                            Image(Rect) // Replace "yourImageName" with the name of your image asset
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 450, height: 140)
                                .padding(.top, -35)
                                .padding(.leading,0)// Adjust size as needed
                            
                            HStack{
                                Image("GlobeIcon")
                                    .renderingMode(.original)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width:30,height:100)
                                    .padding(.top, -150)
                                    .padding(.leading,-155)
                                
                                Image("EthnicityIcon")
                                    .renderingMode(.original)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width:100,height:100)
                                    .padding(.top, -150)
                                    .padding(.leading,-120)
                            }
                            
                            Image(Rect) // Replace "yourImageName" with the name of your image asset
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 450, height: 140)
                                .padding(.top, -35)
                                .padding(.leading,0)// Adjust size as needed
                            
                            HStack{
                                Image("GlobeIcon")
                                    .renderingMode(.original)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width:30,height:100)
                                    .padding(.top, -150)
                                    .padding(.leading,-120)
                                
                                Image("OriginIcon")
                                    .renderingMode(.original)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width:160,height:100)
                                    .padding(.top, -150)
                                    .padding(.leading,-90)
                            }
                            
                            
                            
                        }
                        
                        //let EducationInfo = colorScheme == .dark ? "EducationInfoD" : "EducationInfoL"
                        // Button represented by an image
                        Image("EducationInfoD") // Replace "yourImageName" with the name of your image asset
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 140, height: 200)
                            .padding(.top, -100)
                            .padding(.leading,-160)// Adjust size as needed
                        
                        VStack(spacing: 2){
                            let Rect = colorScheme == .dark ? "RecD" : "RecL"
                            // Button represented by an image
                            Image(Rect) // Replace "yourImageName" with the name of your image asset
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 450, height: 140)
                                .padding(.top, -95)
                                .padding(.leading,0)// Adjust size as needed
                            HStack{
                                Image("YearIcon")
                                    .renderingMode(.original)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width:30,height:100)
                                    .padding(.top, -150)
                                    .padding(.leading,-155)
                                
                                Image("YearWord")
                                    .renderingMode(.original)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width:50,height:100)
                                    .padding(.top, -150)
                                    .padding(.leading,-120)
                            }
                            
                            Image(Rect) // Replace "yourImageName" with the name of your image asset
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 450, height: 140)
                                .padding(.top, -35)
                                .padding(.leading,0)// Adjust size as needed
                            HStack{
                                Image("GradIcon")
                                    .renderingMode(.original)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width:25,height:100)
                                    .padding(.top, -150)
                                    .padding(.leading,-105)
                                
                                Image("GraduationWord")
                                    .renderingMode(.original)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width:180,height:100)
                                    .padding(.top, -150)
                                    .padding(.leading,-75)
                            }
                            
                            Image(Rect) // Replace "yourImageName" with the name of your image asset
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 450, height: 140)
                                .padding(.top, -35)
                                .padding(.leading,0)// Adjust size as needed
                            HStack{
                                Image("ClassesIcon")
                                    .renderingMode(.original)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width:25,height:100)
                                    .padding(.top, -150)
                                    .padding(.leading,-155)
                                
                                Image("ClassesWord")
                                    .renderingMode(.original)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width:90,height:100)
                                    .padding(.top, -150)
                                    .padding(.leading,-120)
                                
                               
                            }
                
                            
                            Image(Rect) // Replace "yourImageName" with the name of your image asset
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 450, height: 140)
                                .padding(.top, -35)
                                .padding(.leading,0)// Adjust size as needed
                            HStack{
                                Image("InternshipsIcon")
                                    .renderingMode(.original)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width:30,height:100)
                                    .padding(.top, -150)
                                    .padding(.leading,-155)
                                
                                Image("InternshipsWord")
                                    .renderingMode(.original)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width:130,height:100)
                                    .padding(.top, -150)
                                    .padding(.leading,-120)
                            }
                            
                            Image(Rect) // Replace "yourImageName" with the name of your image asset
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 450, height: 140)
                                .padding(.top, -35)
                                .padding(.leading,0)// Adjust size as needed
                            HStack{
                                Image("LinksIcon")
                                    .renderingMode(.original)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width:30,height:100)
                                    .padding(.top, -150)
                                    .padding(.leading,-155)
                                
                                Image("LinksWord")
                                    .renderingMode(.original)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width:60,height:100)
                                    .padding(.top, -150)
                                    .padding(.leading,-120)
                            }
                        }
                        //let EducationInfo = colorScheme == .dark ? "EducationInfoD" : "EducationInfoL"
                        // Button represented by an image
                        Image("Appereance") // Replace "yourImageName" with the name of your image asset
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 120, height: 200)
                            .padding(.top, -100)
                            .padding(.leading,-175)// Adjust size as needed
                        
                        VStack(spacing: 2){
                            let Rect = colorScheme == .dark ? "RecD" : "RecL"
                            // Button represented by an image
                            
                            Image(Rect) // Replace "yourImageName" with the name of your image asset
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 450, height: 140)
                                .padding(.top, -95)
                                .padding(.leading,0)// Adjust size as needed
                            HStack{
                                Image("LightIcon")
                                    .renderingMode(.original)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width:40,height:100)
                                    .padding(.top, -150)
                                    .padding(.leading,-155)
                                
                                Image("LightModeWord")
                                    .renderingMode(.original)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width:115,height:100)
                                    .padding(.top, -150)
                                    .padding(.leading,-110)
                            }
                            
                            Image(Rect) // Replace "yourImageName" with the name of your image asset
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 450, height: 260)
                                .padding(.top, -95)
                                .padding(.leading,0)// Adjust size as needed
                            HStack{
                                Image("DarkModeIcon")
                                    .renderingMode(.original)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width:30,height:100)
                                    .padding(.top, -200)
                                    .padding(.leading,-155)
                                
                                Image("DarkModeWord")
                                    .renderingMode(.original)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width:110,height:100)
                                    .padding(.top, -200)
                                    .padding(.leading,-120)
                            }
                        }
                    }
                    
                }
            }
        }
    }
}
#Preview {
    ProfileView()
}
    

