//
//  EventInfo.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by Matthew Segura on 11/21/24.
//

import SwiftUI
import CoreData
import MapKit

struct EventInfoView: View {
    var event: Event // The event to display information for
    @Binding var showView: AppRoute // For dismissing the view
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var notifVM: NotificationViewModel = NotificationViewModel.instance
    @State private var tappedNotification:Bool = false
    @State private var attemptedToEnableNotifications:Bool = false
    @State private var isPressed = false
    @State private var isValidLocation = true
    @State private var foundLocation:MTPlacemark? = nil
    
    @FetchRequest(sortDescriptors: []) private var coreEvents: FetchedResults<CalendarEvent>
    
    var body: some View {
        let dateHelper = DateHelper()
        let startTimeString = dateHelper.getTime(for: event.start.dateTime) // Event start time
        let endTimeString = dateHelper.getTime(for: event.end.dateTime) // Event end time
        let startdateString = dateHelper.getDayFull(for: event.start.dateTime) // Full start date of the event
        
        VStack {
            HStack(alignment: .center) {
                Spacer()
                Text(event.summary)
                    .font(Font.custom("Viga-Regular", size: 45))
                    .foregroundStyle(.profileOrange)
                    .multilineTextAlignment(.center)
                Spacer()
            }
            
            Divider()
                .padding(.horizontal)
                .padding(.bottom)
            
            VStack(alignment: .leading) {
                // Date
                infoRow(text: startdateString, icon: "calendar")
                
                // Time
                infoRow(text: "\(startTimeString) - \(endTimeString)", icon: "clock")
                
                // Location
                infoRow(text: event.location ?? "TBA", icon: "mappin")
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            if isValidLocation
                            {
                                showView = .location
                                AppViewModel.appVM.inMapView = true
                            }
                        }
                    }
            }
            .padding(.top)
            
            if let description = event.description {
                HStack(alignment: .center) {
               
                    VStack {
                        Text("Description")
                            .font(Font.custom("Viga-Regular", size: 20))
                            .foregroundStyle(.adminOrange)
                            .padding(.bottom)
                        
                        Text(description)
                            .font(Font.custom("Viga-Regular", size: 20))
                            .multilineTextAlignment(.center)
                    }
                    
                    
                }
                .padding()
                .padding(.top)
                
            }
        }
        .edgesIgnoringSafeArea(.all)
        .transition(.move(edge: .trailing))
        .onAppear
        {
            tappedNotification = notifVM.pendingNotifications.contains(where: { e in
                e.identifier == event.identifier
            })
            
            if let location = event.location
            {
                let geocoder = CLGeocoder()
                geocoder.geocodeAddressString(location)
                {
                    placemarks, error in
                    isValidLocation = placemarks != nil && placemarks!.count > 0 && error == nil
                    if isValidLocation
                    {
                        let coordinates = placemarks![0].location!.coordinate
                        AppViewModel.appVM.placemark = MTPlacemark(name: event.summary, address: location, latitude: coordinates.latitude, longitude: coordinates.longitude)
                    }
                }
            }
            else {
                isValidLocation = false
            }
        }
        
    }
    
    func infoRow(text: String, icon: String) -> some View {
        HStack(alignment: .center, spacing: 12) {
            
            
            Image(systemName: icon)
                .font(.title)
                .frame(width: 30, alignment: .center)
                .foregroundStyle(.adminOrange)
            
            Text(text)
                .font(Font.custom("Viga-Regular", size: 20))
                .foregroundStyle(colorScheme == .dark ? .white : .black)
            
            Spacer()
        }
        .padding()
        .padding(.leading, 20)
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

//#Preview {
//    EventInfoView(event: Event.mock, showView: .constant(.eventInfo))
//}
