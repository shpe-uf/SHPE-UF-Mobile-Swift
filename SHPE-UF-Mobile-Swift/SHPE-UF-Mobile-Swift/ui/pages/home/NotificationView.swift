//
//  NotificationView.swift
//  SHPE-UF-Mobile-Swift
//  Created by Matthew Segura on 2/15/24.
//  Simar: 02/29/24 fixed icon clickability issue, added comments throughout code.
import SwiftUI

// Define a view for managing notification settings within the app
struct NotificationView: View {
    // Manage the presentation state of the view
    @Environment(\.presentationMode) var presentationMode
    
    // State variables to track which event types are selected for notifications
    @State private var isGBMSelected = false
    @State private var isInfoSelected = false
    @State private var isWorkShopSelected = false
    @State private var isVolunteeringSelected = false
    @State private var isSocialSelected = false
    
    // A flag to manage notification permissions for all event types
    @State private var allowForAll = false
    
    @ObservedObject var viewNotificationModel = NotificationViewModel()
    
    var body: some View {
        // Stack the views vertically with spacing
        VStack(spacing: 20){
            // Use a ZStack for layering the background and button horizontally
            ZStack{
                Constants.orange
                    .frame(height: 93)
                HStack{
                    Button {
                        // Dismiss the current view when the button is pressed
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        // Button label with an image
                        Image("Back")
                            .frame(height:70,alignment: .bottomLeading)
                    }
                    Spacer()
                    // Notification settings title
                    Text("Notification Settings")
                    .font(Font.custom("Viga", size: 24))
                    .foregroundColor(.white)
                    .frame(height: 75, alignment: .bottomLeading)
                    Spacer()
                }
                .padding(.horizontal, 20)
            }
           
            // Stack for the main content area
            ZStack {
                VStack(spacing: 50) {
                    Spacer()
                    // Prompt text for user action
                    Text("Tap an event to get notifications")
                        .font(Font.custom("Viga", size: 20))
                        .multilineTextAlignment(.center)
                        .foregroundColor(Constants.DescriptionHeaderColor)
                        .frame(height: 50, alignment: .bottomLeading)
                    
                    // Horizontal stack for event type buttons
                    HStack(spacing: 30) {
                        // General Body Meetings (GBM) button and label
                        VStack(spacing: 20) {
                            Button(action: {
                                isGBMSelected.toggle()
                                if isGBMSelected {
                                    viewNotificationModel.turnOnEventNotification(eventType: "GBM")
                                } else {
                                    viewNotificationModel.turnOffEventNotification(eventType: "GBM")
                                }
                            }) {
                                ZStack {
                                    Image(isGBMSelected ? "Ellipse_selected" : "Ellipse")
                                        .frame(width: 92, height: 90)
                                    Image("Business_Group")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 42, height: 42)
                                }
                            }
                            Text("GBMs")
                                .font(Font.custom("UniversLTStd", size: 16))
                                .foregroundColor(Constants.DescriptionTextColor)
                        }
                        // Info Sessions button and labels
                        VStack {
                            Button(action: {
                                isInfoSelected.toggle()
                                if isInfoSelected {
                                    viewNotificationModel.turnOnEventNotification(eventType: "Info")
                                } else {
                                    viewNotificationModel.turnOffEventNotification(eventType: "Info")
                                }
                            }) {
                                ZStack {
                                    Image(isInfoSelected ? "Ellipse_selected" : "Ellipse")
                                        .frame(width: 92, height: 90)
                                    Image("Info")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 42, height: 42)
                                }
                            }
                            Text("Info")
                                .font(Font.custom("UniversLTStd", size: 16))
                                .foregroundColor(Constants.DescriptionTextColor)
                            Text("Sessions")
                                .font(Font.custom("UniversLTStd", size: 16))
                                .foregroundColor(Constants.DescriptionTextColor)
                        }
                        // Workshops button and label
                        VStack(spacing: 20) {
                            Button(action: {
                                isWorkShopSelected.toggle()
                                if isWorkShopSelected {
                                    viewNotificationModel.turnOnEventNotification(eventType: "Workshop")
                                } else {
                                    viewNotificationModel.turnOffEventNotification(eventType: "Workshop")
                                }
                            }) {
                                ZStack {
                                    Image(isWorkShopSelected ? "Ellipse_selected" : "Ellipse")
                                        .frame(width: 92, height: 90)
                                    Image("Training")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 42, height: 42)
                                }
                            }
                            Text("Workshops")
                                .font(Font.custom("Univers LT Std", size: 16))
                                .foregroundColor(Constants.DescriptionTextColor)
                        }
                    }
                    
                    // Horizontal stack for Volunteering and Socials buttons
                    HStack(spacing: 30){
                        // Volunteering button with label
                        VStack{
                            Button(action: {
                                isVolunteeringSelected.toggle()
                                if isVolunteeringSelected {
                                    viewNotificationModel.turnOnEventNotification(eventType: "Volunteering")
                                } else {
                                    viewNotificationModel.turnOffEventNotification(eventType: "Volunteering")
                                }
                            }) {
                                ZStack{
                                    Image(isVolunteeringSelected ? "Ellipse_selected" : "Ellipse")
                                        .frame(width: 92, height: 90)
                                    Image("Volunteering")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 42, height: 42)
                                }
                            }
                            Text("Volunteering")
                                .font(Font.custom("UniversLTStd", size: 16))
                                .foregroundColor(Constants.DescriptionTextColor)
                        }
                        // Socials button with label
                        VStack{
                            Button(action: {
                                isSocialSelected.toggle()
                                if isSocialSelected {
                                    viewNotificationModel.turnOnEventNotification(eventType: "Social")
                                } else {
                                    viewNotificationModel.turnOffEventNotification(eventType: "Social")
                                }
                            }) {
                                ZStack{
                                    Image(isSocialSelected ? "Ellipse_selected" : "Ellipse")
                                        .frame(width: 92, height: 90)
                                    Image("Users")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 42, height: 42)
                                }
                            }
                            Text("Socials")
                                .font(Font.custom("UniversLTStd", size: 16))
                                .foregroundColor(Constants.DescriptionTextColor)
                        }
                    }

                    Spacer()
                    
                    // Button to toggle notifications for all event types
                    Button(action: {
                       allowForAll.toggle()
                       // Update the selection state for all event types
                       isGBMSelected = allowForAll
                       isInfoSelected = allowForAll
                       isWorkShopSelected = allowForAll
                       isVolunteeringSelected  = allowForAll
                       isSocialSelected = allowForAll
                        if allowForAll {
                            viewNotificationModel.turnOnEventNotification(eventType: "GBM")
                            viewNotificationModel.turnOnEventNotification(eventType: "Info")
                            viewNotificationModel.turnOnEventNotification(eventType: "Workshop")
                            viewNotificationModel.turnOnEventNotification(eventType: "Volunteering")
                            viewNotificationModel.turnOnEventNotification(eventType: "Social")
                        } else {
                            viewNotificationModel.turnOffEventNotification(eventType: "GBM")
                            viewNotificationModel.turnOffEventNotification(eventType: "Info")
                            viewNotificationModel.turnOffEventNotification(eventType: "Workshop")
                            viewNotificationModel.turnOffEventNotification(eventType: "Volunteering")
                            viewNotificationModel.turnOffEventNotification(eventType: "Social")
                        }
                            
                    }){
                       ZStack{
                           Rectangle()
                               .foregroundColor(allowForAll ? Color(red: 0.58, green: 0.22, blue: 0.08) : Constants.orange)
                               .frame(width: 254, height: 41)
                               .cornerRadius(30)
                           Text("Allow for all")
                               .font(Font.custom("UniversLTStd", size: 16))
                               .foregroundColor(.white)
                               .frame(width: 106.88688, height: 15.94444, alignment: .topLeading)
                       }
                       .frame(width: 254, height: 41)
                    }
                    Spacer()
                }
            }
        }
        .background(Constants.BackgroundColor) // Set the background color for the view
        .edgesIgnoringSafeArea(.all) // Ignore the safe area to extend to the edges
        .navigationBarHidden(true) // Hide the navigation bar for this view
    }
}

//Preview of the NotificationView
#Preview {
    NotificationView()
}
