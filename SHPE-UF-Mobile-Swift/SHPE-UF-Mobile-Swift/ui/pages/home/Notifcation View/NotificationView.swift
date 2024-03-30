//Notification View

//  NotificationView.swift
//  SHPE-UF-Mobile-Swift
//  Created by Matthew Segura on 2/15/24.
//  Simar: 02/29/24 fixed icon clickability issue, added comments throughout code.
import SwiftUI
import CoreData

// Define a view for managing notification settings within the app
struct NotificationView: View {
    @ObservedObject var viewModel:HomeViewModel
    // Manage the presentation state of the view
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: []) private var coreEvents: FetchedResults<CalendarEvent>
    @FetchRequest(sortDescriptors: []) private var user: FetchedResults<User>
    
    // A flag to manage notification permissions for all event types
    @State private var allowForAll = false
    
    @StateObject var viewNotificationModel = NotificationViewModel.instance
    
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
                    .font(Font.custom("Viga-Regular", size: 24))
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
                        .font(Font.custom("Viga-Regular", size: 20))
                        .multilineTextAlignment(.center)
                        .foregroundColor(colorScheme == .dark ? Constants.lightTextColor : Constants.DayNumberTextColor)
                        .frame(height: 50, alignment: .bottomLeading)
                    
                    // Horizontal stack for event type buttons
                    HStack(spacing: 30) {
                        // Each event type button with its corresponding label and icon
                        eventButtonSection(eventName: "GBM", eventIcon: "Business_Group", isSelected: $viewNotificationModel.isGBMSelected)
                        eventButtonSection(eventName: "Info Sessions", eventIcon: "Info", isSelected: $viewNotificationModel.isInfoSelected)
                        eventButtonSection(eventName: "Workshops", eventIcon: "Training", isSelected: $viewNotificationModel.isWorkShopSelected)
                    }
                    
                    // Horizontal stack for Volunteering and Socials buttons
                    HStack(spacing: 30){
                        eventButtonSection(eventName: "Volunteering", eventIcon: "Volunteering", isSelected: $viewNotificationModel.isVolunteeringSelected)
                        eventButtonSection(eventName: "Socials", eventIcon: "Users", isSelected: $viewNotificationModel.isSocialSelected)
                    }

                    Spacer()
                    
                    // Button to toggle notifications for all event types
                    Button(action: {
                       allowForAll.toggle()
                       // Update the selection state for all event types
                        viewNotificationModel.isGBMSelected = allowForAll
                        viewNotificationModel.isInfoSelected = allowForAll
                        viewNotificationModel.isWorkShopSelected = allowForAll
                        viewNotificationModel.isVolunteeringSelected  = allowForAll
                        viewNotificationModel.isSocialSelected = allowForAll
                        CoreFunctions().editUserNotificationSettings(users: user, viewContext: viewContext, shpeito: AppViewModel.appVM.shpeito)
                        if allowForAll {
                            viewNotificationModel.turnOnEventNotification(events: viewModel.events,eventType: "GBM", fetchedEvents: coreEvents, viewContext: viewContext)
                            viewNotificationModel.turnOnEventNotification(events: viewModel.events,eventType: "Info Sessions", fetchedEvents: coreEvents, viewContext: viewContext)
                            viewNotificationModel.turnOnEventNotification(events: viewModel.events,eventType: "Workshops", fetchedEvents: coreEvents, viewContext: viewContext)
                            viewNotificationModel.turnOnEventNotification(events: viewModel.events,eventType: "Volunteering", fetchedEvents: coreEvents, viewContext: viewContext)
                            viewNotificationModel.turnOnEventNotification(events: viewModel.events,eventType: "Socials", fetchedEvents: coreEvents, viewContext: viewContext)
                        } else {
                            viewNotificationModel.turnOffEventNotification(events: viewModel.events,eventType: "GBM", fetchedEvents: coreEvents, viewContext: viewContext)
                            viewNotificationModel.turnOffEventNotification(events: viewModel.events,eventType: "Info Sessions", fetchedEvents: coreEvents, viewContext: viewContext)
                            viewNotificationModel.turnOffEventNotification(events: viewModel.events,eventType: "Workshops", fetchedEvents: coreEvents, viewContext: viewContext)
                            viewNotificationModel.turnOffEventNotification(events: viewModel.events,eventType: "Volunteering", fetchedEvents: coreEvents, viewContext: viewContext)
                            viewNotificationModel.turnOffEventNotification(events: viewModel.events,eventType: "Socials", fetchedEvents: coreEvents, viewContext: viewContext)
                        }
                            
                    }){
                       ZStack{
                           Rectangle()
                               .foregroundColor(allowForAll ? Color(red: 0.58, green: 0.22, blue: 0.08) : Constants.orange)
                               .frame(width: 254, height: 41)
                               .cornerRadius(30)
                           Text(allowForAll ? "Remove all" : "Allow for all")
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
        .onAppear {
            // Check for notification permission when the view appears
            viewNotificationModel.checkForPermission()
        }
        .background(colorScheme == .dark ? Constants.darkModeBackground : Constants.BackgroundColor)
        .edgesIgnoringSafeArea(.all) // Ignore the safe area to extend to the edges
        .navigationBarHidden(true) // Hide the navigation bar for this view
    }

    // Helper function for creating button sections
    private func eventButtonSection(eventName: String, eventIcon: String, isSelected: Binding<Bool>) -> some View {
        VStack(spacing: 20) {
            Button(action: {
                if !isSelected.wrappedValue {
                    viewNotificationModel.turnOnEventNotification(events: viewModel.events,eventType: eventName, fetchedEvents: coreEvents, viewContext: viewContext)
                    saveNotificationSetting(eventType: eventName, state: true)
                } else {
                    viewNotificationModel.turnOffEventNotification(events: viewModel.events,eventType: eventName, fetchedEvents: coreEvents, viewContext: viewContext)
                    saveNotificationSetting(eventType: eventName, state: false)
                }
                
            }) {
                ZStack {
                    Image(isSelected.wrappedValue ? "Ellipse_selected" : colorScheme == .dark ? "dark_ellipse" :"Ellipse")
                        .frame(width: 92, height: 90)
                        
                    Image(eventIcon)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 42, height: 42)
                }
            }
            Text(eventName)
                .font(Font.custom("UniversLTStd", size: 16))
                .foregroundColor(colorScheme == .dark ? Constants.lightTextColor : Constants.DayNumberTextColor)
        }
    }
    
    private func saveNotificationSetting(eventType:String, state:Bool)
    {
        switch eventType
        {
        case "GBM":
            viewNotificationModel.isGBMSelected = state
        case "Info Sessions":
            viewNotificationModel.isInfoSelected = state
        case "Workshops":
            viewNotificationModel.isWorkShopSelected = state
        case "Volunteering":
            viewNotificationModel.isVolunteeringSelected = state
        case "Socials":
            viewNotificationModel.isSocialSelected = state
        default:
            print("Invalid notification type")
        }
        CoreFunctions().editUserNotificationSettings(users: user, viewContext: viewContext, shpeito: AppViewModel.appVM.shpeito)
    }
}

#Preview{
    NotificationView(viewModel: HomeViewModel())
}
    
