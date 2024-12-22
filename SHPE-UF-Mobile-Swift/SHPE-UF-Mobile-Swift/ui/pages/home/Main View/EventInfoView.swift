//
//  EventInfo.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by Matthew Segura on 11/21/24.
//

import SwiftUI
import CoreData

struct EventInfoView: View {
    var event: Event // The event to display information for
    @Binding var showView: String // For dismissing the view
    @Environment(\.colorScheme) var colorScheme
    @State private var notifVM: NotificationViewModel = NotificationViewModel.instance
    @State private var tappedNotification:Bool = false
    @State private var attemptedToEnableNotifications:Bool = false
    @State private var isPressed = false
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: []) private var coreEvents: FetchedResults<CalendarEvent>
    
    var body: some View {
        let dateHelper = DateHelper()
        let startTimeString = dateHelper.getTime(for: event.start.dateTime) // Event start time
        let endTimeString = dateHelper.getTime(for: event.end.dateTime) // Event end time
        let startdateString = dateHelper.getDayFull(for: event.start.dateTime) // Full start date of the event
        
        let (iconImage, eventImage) = eventTypeVariables(event: event) // Icons based on the event type
        ZStack {
            if attemptedToEnableNotifications
            {
                VisualEffectBlur(blurStyle: .systemUltraThinMaterial)
                                    .edgesIgnoringSafeArea(.all)
                                    .zIndex(998)
                
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
                                    attemptedToEnableNotifications = false
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
                        withAnimation(.easeInOut) {
                            if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                                UIApplication.shared.open(appSettings)
                            }
                            attemptedToEnableNotifications = false
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
            }
            
            VStack {
                Rectangle()
                .foregroundColor(.clear)
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.35)
                .background(
                Image(eventImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.35, alignment: .topLeading)
                .clipped()
                )
                Spacer()
            }
            
            VStack {
                // Back button
                HStack {
                    Button {
                        withAnimation(.easeInOut(duration: 0.2))
                        {
                            showView = "HomeView"
                        }
                    } label: {
                        ZStack {
                            Image("Ellipse_back")
                                .frame(width: UIScreen.main.bounds.width * 0.15, height: UIScreen.main.bounds.height * 0.075)
                            Image("Back")
                                .frame(width: UIScreen.main.bounds.width * 0.15, height: UIScreen.main.bounds.height * 0.10)
                        }
                    }
                    .padding(.horizontal, UIScreen.main.bounds.width * 0.05)
                    .padding(.vertical, UIScreen.main.bounds.height * 0.04)
                    
                    Spacer()

                }
                .padding(.bottom, UIScreen.main.bounds.height * 0.06)
                
                
                // Event information card
                ZStack{
                    Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: UIScreen.main.bounds.width * 1, height: UIScreen.main.bounds.height * 0.75)
                    .alignmentGuide(.bottom) { d in d[.bottom] }
                    .background(colorScheme == .dark ? Constants.darkModeBackground : Constants.BackgroundColor)
                    .cornerRadius(20)
                    .overlay(
                        ScrollView{
                        VStack{
                            // Event title and icon
                            HStack(alignment: .top){
                                Text(event.summary)
                                .bold()
                                .font(Font.custom("Viga-Regular", size: 32))
                                .foregroundColor(Constants.orange)
                                .frame(width: UIScreen.main.bounds.width * 0.5, alignment: .leading)
                                .lineLimit(3)
                                Spacer()
                                VStack
                                {
                                    Image(iconImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: UIScreen.main.bounds.width * 0.04, height: UIScreen.main.bounds.height * 0.04)
                                    
                                    ZStack {
                                        Image(tappedNotification ? "Ellipse_selected" : colorScheme == .dark ? "dark_ellipse" :"Ellipse")
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: UIScreen.main.bounds.width * 0.035, height: UIScreen.main.bounds.height * 0.035)
                                            
                                        Image("Doorbell")
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: UIScreen.main.bounds.width * 0.025, height: UIScreen.main.bounds.height * 0.025)
                                    }
                                    .frame(width: UIScreen.main.bounds.width * 0.03, height: UIScreen.main.bounds.height * 0.03)
                                    .onTapGesture {
                                        // Check if notifications have been allowed
                                        notifVM.checkForPermission{
                                            permission in
                                            
                                            if permission
                                            {
                                                if notifVM.pendingNotifications.contains(where: { e in
                                                    e.identifier == event.identifier
                                                })
                                                {
                                                    tappedNotification = false
                                                    notifVM.removeNotificationForSingleEvent(event: event, fetchedEvents: coreEvents, viewContext: viewContext)
                                                }
                                                else
                                                {
                                                    tappedNotification = true
                                                    notifVM.notifyForSingleEvent(event: event, fetchedEvents: coreEvents, viewContext: viewContext)
                                                }
                                            }
                                            else
                                            {
                                                withAnimation(.easeInOut) {
                                                    attemptedToEnableNotifications = true
                                                }
                                            }
                                            
                                        }
                                    }
                                }
                            }
                            .frame(width: UIScreen.main.bounds.width * 0.6, alignment: .leading)
                            .frame(maxWidth: UIScreen.main.bounds.width)
                            .padding(.top, UIScreen.main.bounds.height * 0.05)
                            
                            VStack(alignment:.leading){
                                // Event date
                                HStack(spacing: UIScreen.main.bounds.width * 0.05){
                                    Rectangle()
                                        .foregroundColor(.clear)
                                        .frame(width: UIScreen.main.bounds.width * 0.08, height: UIScreen.main.bounds.height * 0.08)
                                        .background(
                                            Image("Calendar")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                        )
                                    Text(startdateString)
                                        .font(Font.custom("UniversLTStd", size: 18))
                                        .foregroundColor(colorScheme == .dark ? Constants.lightTextColor : Constants.DayNumberTextColor)
                                }
                                .frame(width: UIScreen.main.bounds.width * 0.6, alignment: .leading)
                            
                            
                                // Event time
                                HStack(spacing: UIScreen.main.bounds.width * 0.05){
                                    Rectangle()
                                        .foregroundColor(.clear)
                                        .frame(width: UIScreen.main.bounds.width * 0.08, height: UIScreen.main.bounds.height * 0.08)
                                        .background(
                                            Image("Timer")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                        )
                                    Text("\(startTimeString) - \(endTimeString)")
                                        .font(Font.custom("UniversLTStd", size: 18))
                                        .foregroundColor(colorScheme == .dark ? Constants.lightTextColor : Constants.DayNumberTextColor)
                                }
                                .frame(width: UIScreen.main.bounds.width * 0.6, alignment: .leading)
                               
                                // Event location
                                HStack(spacing: UIScreen.main.bounds.width * 0.05){
                                    Rectangle()
                                    .foregroundColor(.clear)
                                    .frame(width: UIScreen.main.bounds.width * 0.08, height: UIScreen.main.bounds.height * 0.08)
                                    .background(
                                        Image("iconLocation")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                    )
                                    Text(String(event.location ?? "TBA"))
                                      .font(Font.custom("UniversLTStd", size: 18))
                                      .foregroundColor(Constants.orange)
                                      .underline()
                                      .scaleEffect(isPressed ? 0.95 : 1.0)
                                      .animation(.easeInOut(duration: 0.2), value: isPressed)
                                      .onTapGesture { //This is to go to the LocationView
                                          withAnimation(.easeInOut(duration: 0.2)) {
                                              showView = "LocationView"
                                          }
                                      }
                                      .simultaneousGesture(
                                          DragGesture(minimumDistance: 0)
                                              .onChanged { _ in isPressed = true } 
                                              .onEnded { _ in isPressed = false }
                                      )
                                }
                                .frame(width: UIScreen.main.bounds.width * 0.6, alignment: .leading)
                                
                                // Event description header
                                if let description = event.description
                                {
                                    Text("Description:")
                                    .font(Font.custom("UniversLTStd", size: 18))
                                    .foregroundColor(colorScheme == .dark ? Constants.teal : Constants.DescriptionHeaderColor)
                                    .frame(width: UIScreen.main.bounds.width * 0.265, alignment: .leading)
                                    .padding(.top, UIScreen.main.bounds.height * 0.035)
                                    // Event description text
                                    //Need to have event  description variables in the future
                                    Text(description)
                                      .font(Font.custom("UniversLTStd", size: 18))
                                      .foregroundColor(colorScheme == .dark ? Constants.lightTextColor : Constants.DayNumberTextColor)
                                      .frame(width: UIScreen.main.bounds.width * 0.6, height: UIScreen.main.bounds.height * 0.235, alignment: .topLeading)
                                }
                            }
                            Spacer()
                        }
                    }
                                                
                        
                    )
                    
                }
            }
        }
        .background(colorScheme == .dark ? Constants.darkModeBackground : Constants.BackgroundColor)
        .edgesIgnoringSafeArea(.all)
        .transition(.move(edge: .trailing))
        .onAppear
        {
            tappedNotification = notifVM.pendingNotifications.contains(where: { e in
                e.identifier == event.identifier
            })
        }
        
    }

    // Returns icons based on the event type
    func eventTypeVariables(event: Event) -> (String , String) {
        switch event.eventType {
        case "GBM":
            return ( "iconGBM_Full" , "GBMimage")
        case "Workshop":
            return ("iconWorkShop_Full", "workShopImage")
        case "Social":
            return ("iconSocial_Full", "socialImage")
        case "Volunteering":
            return ("iconVolunteering_full", "volunteeringImage")
        case "Info":
            return ("iconInfo_full","infoImage")
        default:
            return ("Business_Group", "GBMimage")
        }
    }
}

