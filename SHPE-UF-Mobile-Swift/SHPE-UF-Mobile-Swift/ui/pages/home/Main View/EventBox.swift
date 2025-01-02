//
//  EventBox.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by Matthew Segura on 12/20/24.
//
import SwiftUI
import CoreData

struct EventBox: View {
    var event: Event
    @Environment(\.colorScheme) var colorScheme
    @State private var isAnimating = false
    @State private var ongoing = false

    var body: some View {
        let dateHelper = DateHelper()
        let startTimeString = dateHelper.getTime(for: event.start.dateTime)
        let endTimeString = dateHelper.getTime(for: event.end.dateTime)
        let startDateString = dateHelper.getDayFull(for: event.start.dateTime)
        let (color, iconImage) = eventTypeVariables(event: event)

        Group {
            if startTimeString == endTimeString {
                EventNoTimeView(
                    event: event,
                    color: color,
                    iconImage: iconImage,
                    startDateString: startDateString,
                    isAnimating: $isAnimating,
                    ongoing: $ongoing
                )
            } else {
                EventWithTimeView(
                    event: event,
                    color: color,
                    iconImage: iconImage,
                    startDateString: startDateString,
                    startTimeString: startTimeString,
                    endTimeString: endTimeString,
                    isAnimating: $isAnimating,
                    ongoing: $ongoing
                )
            }
        }
    }

    func eventTypeVariables(event: Event) -> (Color, String) {
        switch event.eventType {
        case "GBM":
            return (Constants.grey, "Business_Group")
        case "Workshop":
            return (Constants.orange, "Training")
        case "Social":
            return (Constants.blue, "Users")
        case "Volunteering":
            return (Constants.green, "Volunteering")
        case "Info":
            return (Constants.teal, "Info")
        default:
            return (.clear, "Business_Group")
        }
    }
}

struct EventNoTimeView: View {
    var event: Event
    var color: Color
    var iconImage: String
    var startDateString: String
    @Binding var isAnimating: Bool
    @Binding var ongoing: Bool
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: UIScreen.main.bounds.width * 0.8, height: 69)
                .background(color)
                .cornerRadius(25)
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(isAnimating ? Color.lorange : Color.lorange.opacity(0.5), lineWidth: isAnimating ? 4 : ongoing ? 2 : 0)
                        .animation(Animation.linear(duration: 1).repeatForever(autoreverses: true), value: ongoing)
                )
                .onAppear {
                    self.ongoing = event.start.dateTime <= Date() && event.end.dateTime >= Date()
                    self.isAnimating = ongoing
                }
            
            VStack{
                HStack{
                    Text(event.summary)
                        .font(Font.custom("UniversLTStd", size: 15))
                        .foregroundColor(.white)
                        .frame(alignment: .topLeading)
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 20, height: 20)
                        .background(
                            
                            Image(iconImage)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        )
                }
                .frame(width: UIScreen.main.bounds.width * 0.7, height: 17, alignment: .topLeading)
                
                
                HStack(spacing: 5) {
                    HStack{
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 24, height: 24)
                            .background(
                                Image("Calendar")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            )
                        Text(startDateString)
                            .font(Font.custom("UniversLTStd", size: 12))
                            .foregroundColor(.white)
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.7, height: 17, alignment: .topLeading)
                    
                    Spacer()
                    
                }
                .frame(width: UIScreen.main.bounds.width * 0.7)
            }
            
        }
    }
}

struct EventWithTimeView: View {
    var event: Event
    var color: Color
    var iconImage: String
    var startDateString: String
    var startTimeString: String
    var endTimeString: String
    @Binding var isAnimating: Bool
    @Binding var ongoing: Bool
    
    var body: some View {
        //Prints out events with set times
        ZStack{
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: UIScreen.main.bounds.width * 0.8, height: 69)
                .background(color)
                .cornerRadius(25)
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(isAnimating ? Color.lorange : Color.lorange.opacity(0.5), lineWidth: isAnimating ? 4 : ongoing ? 2 : 0)
                        .animation(Animation.linear(duration: 1).repeatForever(autoreverses: true))
                )
                .onAppear {
                    self.ongoing = event.start.dateTime <= Date() && event.end.dateTime >= Date()
                    self.isAnimating = ongoing
                }
            
            VStack{
                HStack{
                    Text(event.summary)
                        .font(Font.custom("UniversLTStd", size: 15))
                        .foregroundColor(.white)
                    
                        .frame(alignment: .topLeading)
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 20, height: 20)
                        .background(
                            
                            Image(iconImage)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        )
                }
                .frame(width: UIScreen.main.bounds.width * 0.7, height: 17, alignment: .topLeading)
                
                
                HStack(spacing: 5) {
                    HStack{
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 24, height: 24)
                            .background(
                                Image("Calendar")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            )
                        Text(startDateString)
                            .font(Font.custom("UniversLTStd", size: 12))
                            .foregroundColor(.white)
                    }
                    .frame(width: 115, height: 17, alignment: .topLeading)
                    Spacer()
                    HStack{
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 24, height: 24)
                            .background(
                                Image("Timer")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            )
                        
                        Text("\(startTimeString) - \(endTimeString)")
                            .font(Font.custom("UniversLTStd", size: 12))
                            .foregroundColor(.white)
                    }
                    .frame(height: 17, alignment: .topLeading)
                    
                    
                }
                .frame(width: UIScreen.main.bounds.width * 0.7)
            }
            
        }
    
    }
}
