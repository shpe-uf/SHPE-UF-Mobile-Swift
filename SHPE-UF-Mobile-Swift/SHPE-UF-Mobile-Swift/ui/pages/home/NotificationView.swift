//
//  NotificationView.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by Matthew Segura on 2/15/24.
//

import SwiftUI

struct NotificationView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private var isGBMSelected = false
    @State private var isInfoSelected = false
    @State private var isWorkShopSelected = false
    @State private var isVolunteeringSelected = false
    @State private var isSocialSelected = false
    
    @State private var allowForAll = false
    
    var body: some View {
        // Your content for the notification button page
       
        VStack(spacing: 20){
            ZStack{
                Constants.Orange
                    .frame(height: 93)
                HStack{
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        
                        Image("Back")
                            .frame(height:70,alignment: .bottomLeading)
                
                    }
                    Spacer()
                    Text("Notification Settings")
                    .font(Font.custom("Viga", size: 24))
                    .foregroundColor(.white)
                    .frame(height: 75, alignment: .bottomLeading)
                    Spacer()
                }
                .padding(.horizontal, 20)
                
               
            }
           
            ZStack{
                VStack(spacing: 50){
                    Spacer()
                    Text("Tap which type of event you want notifications for")
                    .font(Font.custom("Viga", size: 20))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Constants.DescriptionHeaderColor)
                    .frame(height: 50,alignment: .bottomLeading)
                   
                    HStack(spacing: 30){
                        VStack(spacing:20){
                            ZStack{
                                Button(action: {
                                   isGBMSelected.toggle()
                               }) {
                                   Image(isGBMSelected ? "Ellipse_selected" : "Ellipse")
                                       .frame(width: 92, height: 90)
                               }
                               
                                Rectangle()
                                .foregroundColor(.clear)
                                .frame(width: 42, height: 42)
                                .background(
                                    Image("Business_Group")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                )
                                .cornerRadius(5)
                            }
                            Text("GBMs")
                            .font(Font.custom("Univers LT Std", size: 16))
                            .foregroundColor(Constants.DescriptionTextColor)
                        }
                        VStack{
                            ZStack{
                                Button(action: {
                                   isInfoSelected.toggle()
                               }) {
                                   Image(isInfoSelected ? "Ellipse_selected" : "Ellipse")
                                       .frame(width: 92, height: 90)
                               }
                                Rectangle()
                                .foregroundColor(.clear)
                                .frame(width: 42, height: 42)
                                .background(
                                Image("Info")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                )
                                .cornerRadius(5)
                            }
                            Text("Info")
                            .font(Font.custom("Univers LT Std", size: 16))
                            .foregroundColor(Constants.DescriptionTextColor)
                            Text("Sessions")
                            .font(Font.custom("Univers LT Std", size: 16))
                            .foregroundColor(Constants.DescriptionTextColor)
                        }
                        VStack(spacing: 20){
                            ZStack{
                                Button(action: {
                                   isWorkShopSelected.toggle()
                               }) {
                                   Image(isWorkShopSelected ? "Ellipse_selected" : "Ellipse")
                                       .frame(width: 92, height: 90)
                               }
                                Rectangle()
                                .foregroundColor(.clear)
                                .frame(width: 42, height: 42)
                                .background(
                                Image("Training")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                )
                                .cornerRadius(5)
                            }
                            Text("Workshops")
                            .font(Font.custom("Univers LT Std", size: 16))
                            .foregroundColor(Constants.DescriptionTextColor)
                        }
                        
                        
                    }
                    HStack(spacing: 30){
                        VStack{
                            ZStack{
                                Button(action: {
                                   isVolunteeringSelected.toggle()
                               }) {
                                   Image(isVolunteeringSelected ? "Ellipse_selected" : "Ellipse")
                                       .frame(width: 92, height: 90)
                               }
                                Rectangle()
                                .foregroundColor(.clear)
                                .frame(width: 42, height: 42)
                                .background(
                                Image("Volunteering")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                )
                                .cornerRadius(5)
                            }
                            Text("Volunteering")
                            .font(Font.custom("Univers LT Std", size: 16))
                            .foregroundColor(Constants.DescriptionTextColor)
                        }
                        VStack{
                            ZStack{
                                Button(action: {
                                   isSocialSelected.toggle()
                               }) {
                                   Image(isSocialSelected ? "Ellipse_selected" : "Ellipse")
                                       .frame(width: 92, height: 90)
                               }
                                Rectangle()
                                .foregroundColor(.clear)
                                .frame(width: 42, height: 42)
                                .background(
                                Image("Users")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                )
                                .cornerRadius(5)
                            }
                            Text("Socials")
                              .font(Font.custom("Univers LT Std", size: 16))
                              .foregroundColor(Constants.DescriptionTextColor)
                        }
                        
                    }
                    Spacer()
                    
                    Button(action: {
                       allowForAll.toggle()
                       // Set the selection state of all ellipses based on allowForAll
                       isGBMSelected = allowForAll
                       isInfoSelected = allowForAll
                       isWorkShopSelected = allowForAll
                       isVolunteeringSelected  = allowForAll
                       isSocialSelected = allowForAll
                            
                    }){
                       ZStack{
                           Rectangle()
                               .foregroundColor(.clear)
                               .frame(width: 254, height: 41)
                               .background(Constants.Orange)
                               .cornerRadius(30)
                           Text("Allow for all")
                               .font(Font.custom("Univers LT Std", size: 16))
                               .foregroundColor(.white)
                               .frame(width: 106.88688, height: 15.94444, alignment: .topLeading)
                       }
                       .frame(width: 254, height: 41)
                    }
                    Spacer()
                }
              
            }
           
        }
        .background(Constants.BackgroundColor)
        .edgesIgnoringSafeArea(.all)
        .navigationBarHidden(true)
        
        
    }
}

#Preview {
    NotificationView()
}
