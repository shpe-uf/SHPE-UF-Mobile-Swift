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
    @Binding var showView: String
    // Manage the presentation state of the view
    @Environment(\.colorScheme) var colorScheme
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: []) private var coreEvents: FetchedResults<CalendarEvent>
    @FetchRequest(sortDescriptors: []) private var user: FetchedResults<User>
    
    // A flag to manage notification permissions for all event types
    @State private var allowForAll = false
    @State private var attemptedToEnableNotifications:Bool = false
    
    @StateObject var viewNotificationModel = NotificationViewModel.instance
    
    var body: some View {
        // Stack the views vertically with spacing
        VStack(spacing: 20){
            // Use a ZStack for layering the background and button horizontally
            
            ZStack{
                Constants.orange
                    .frame(height: 110)
                HStack{
                    Button {
                        // Dismiss the current view when the button is pressed
                        showView = "HomeView"
                    } label: {
                        // Button label with an image
                        Image("Back")
                            .frame(height:75,alignment: .bottomLeading)
                    }
                    Spacer()
                    // Notification settings title
                    Text("Notification Settings")
                        .font(Font.custom("Viga-Regular", size: 24))
                        .foregroundColor(.white)
                        .frame(height: 85, alignment: .bottomLeading)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
            }
            // Stack for the main content area
            ZStack {
                if attemptedToEnableNotifications
                {
                    VisualEffectBlur(blurStyle: .systemUltraThinMaterial)
                                        .edgesIgnoringSafeArea(.all)
                                        .zIndex(998)
                                        .offset(y:-20)
                    
                    VStack(alignment: .center)
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
                                        showView = "HomeView"
                                    }
                                }
                        }
                        
                        Spacer()
                        
                        Text("Trying to Stay Notified?")
                            .foregroundStyle(Color.white)
                            .font(Font.custom("Viga-Regular", size: 24))
                            .padding(.bottom, 10)
                        
                        
                        Text("Please go to your device's \"Settings\" and enable notifications for SHPE UF")
                            .multilineTextAlignment(.center)
                            .foregroundStyle(Color.white)
                            .font(Font.custom("", size: 16))
                        
                        Spacer()
                        
                        Button {
                            if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                                UIApplication.shared.open(appSettings)
                            }
                            
                        } label: {
                            HStack
                            {
                                Text("Go to Settings")
                                    .foregroundStyle(Color.white)
                                    .font(Font.custom("Viga-Regular", size: 24))
                                    .padding(.trailing, 5)
                            }
                            .padding(.vertical, 5)
                            .padding(.horizontal, 30)
                            .background(Color.darkdarkBlue)
                            .cornerRadius(12)
                        }
                        .padding(.bottom, 20)

                    }
                    .zIndex(999)
                    .padding()
                    .frame(width: 309, height: 270, alignment: .center)
                    .background(Color.profileOrange)
                    .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 10)))
                    .offset(y:-20)
                }
                
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
                        eventButtonSection(eventName: "GBM", eventIcon: "Business_Group", isSelected: $viewNotificationModel.isGBMSelected, eventType: "GBM")
                        eventButtonSection(eventName: "Info Sessions", eventIcon: "Info", isSelected: $viewNotificationModel.isInfoSelected, eventType: "Info")
                        eventButtonSection(eventName: "Workshops", eventIcon: "Training", isSelected: $viewNotificationModel.isWorkShopSelected, eventType: "Workshop")
                    }
                    
                    // Horizontal stack for Volunteering and Socials buttons
                    HStack(spacing: 30){
                        eventButtonSection(eventName: "Volunteering", eventIcon: "Volunteering", isSelected: $viewNotificationModel.isVolunteeringSelected, eventType: "Volunteering")
                        eventButtonSection(eventName: "Socials", eventIcon: "Users", isSelected: $viewNotificationModel.isSocialSelected, eventType: "Social")
                    }

                    Spacer()
                    
                    // Button to toggle notifications for all event types
                    Button(action: {
                        allowForAll.toggle()
                        viewNotificationModel.cleanUpDeliveredNotifications()
                        
                        if allowForAll {
                            viewNotificationModel.turnOnEventNotification(events: viewModel.events,eventType: "GBM", fetchedEvents: coreEvents, viewContext: viewContext)
                            viewNotificationModel.turnOnEventNotification(events: viewModel.events,eventType: "Info", fetchedEvents: coreEvents, viewContext: viewContext)
                            viewNotificationModel.turnOnEventNotification(events: viewModel.events,eventType: "Workshop", fetchedEvents: coreEvents, viewContext: viewContext)
                            viewNotificationModel.turnOnEventNotification(events: viewModel.events,eventType: "Volunteering", fetchedEvents: coreEvents, viewContext: viewContext)
                            viewNotificationModel.turnOnEventNotification(events: viewModel.events,eventType: "Social", fetchedEvents: coreEvents, viewContext: viewContext)
                        } else {
                            viewNotificationModel.turnOffEventNotification(events: viewModel.events,eventType: "GBM", fetchedEvents: coreEvents, viewContext: viewContext)
                            viewNotificationModel.turnOffEventNotification(events: viewModel.events,eventType: "Info", fetchedEvents: coreEvents, viewContext: viewContext)
                            viewNotificationModel.turnOffEventNotification(events: viewModel.events,eventType: "Workshop", fetchedEvents: coreEvents, viewContext: viewContext)
                            viewNotificationModel.turnOffEventNotification(events: viewModel.events,eventType: "Volunteering", fetchedEvents: coreEvents, viewContext: viewContext)
                            viewNotificationModel.turnOffEventNotification(events: viewModel.events,eventType: "Social", fetchedEvents: coreEvents, viewContext: viewContext)
                        }
                        
                        CoreFunctions().editUserNotificationSettings(users: user, viewContext: viewContext, shpeito: AppViewModel.appVM.shpeito)
                        
                        viewNotificationModel.verifyNotifications()
                            
                    }){
                       ZStack{
                           Rectangle()
                               .foregroundColor(allowForAll ? Color(red: 0.58, green: 0.22, blue: 0.08) : Constants.orange)
                               .frame(width: 254, height: 41)
                               .cornerRadius(30)
                           Text(allowForAll ? "Remove all" : "Allow for all")
                               .font(Font.custom("UniversLTStd", size: 16))
                               .foregroundColor(.white)
                               .frame(width: 106.88688, height: 15.94444, alignment: .center)
                       }
                       .frame(width: 254, height: 41)
                       .padding(.vertical)
                    }
                    .padding(.bottom, 20)
                    Spacer()
                }
            }
        }
        .onAppear {
            // Check for notification permission when the view appears
            viewNotificationModel.checkForPermission
            {
                permission in
                
                if permission
                {
                    allowForAll = viewNotificationModel.isGBMSelected && viewNotificationModel.isInfoSelected && viewNotificationModel.isSocialSelected && viewNotificationModel.isVolunteeringSelected && viewNotificationModel.isWorkShopSelected
//                    viewNotificationModel.verifyNotifications()
                }
                else
                {
                    withAnimation(.easeIn)
                    {
                        attemptedToEnableNotifications = true
                    }
                }
            }
        }
        .background(colorScheme == .dark ? Constants.darkModeBackground : Constants.BackgroundColor)
        .edgesIgnoringSafeArea(.all) // Ignore the safe area to extend to the edges
        .navigationBarHidden(true) // Hide the navigation bar for this view
    }

    // Helper function for creating button sections
    private func eventButtonSection(eventName: String, eventIcon: String, isSelected: Binding<Bool>, eventType:String) -> some View {
        VStack(spacing: 20) {
            Button(action: {
                viewNotificationModel.cleanUpDeliveredNotifications()
                
                if !isSelected.wrappedValue {
                    viewNotificationModel.turnOnEventNotification(events: viewModel.events,eventType: eventType, fetchedEvents: coreEvents, viewContext: viewContext)
                    saveNotificationSetting(eventType: eventType, state: true)
                } else {
                    viewNotificationModel.turnOffEventNotification(events: viewModel.events,eventType: eventType, fetchedEvents: coreEvents, viewContext: viewContext)
                    saveNotificationSetting(eventType: eventType, state: false)
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
        case "Info":
            viewNotificationModel.isInfoSelected = state
        case "Workshop":
            viewNotificationModel.isWorkShopSelected = state
        case "Volunteering":
            viewNotificationModel.isVolunteeringSelected = state
        case "Social":
            viewNotificationModel.isSocialSelected = state
        default:
            print("Invalid notification type")
        }
        CoreFunctions().editUserNotificationSettings(users: user, viewContext: viewContext, shpeito: AppViewModel.appVM.shpeito)
    }
}
    
