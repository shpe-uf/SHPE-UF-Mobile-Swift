//
//  EventInfo.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by Matthew Segura on 11/21/24.
//

import SwiftUI

struct EventInfoView: View {
    var event: Event // The event to display information for
    @Binding var showView: AppRoute // For dismissing the view

    @Environment(\.colorScheme) var colorScheme

    @State private var isPressed = false

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
