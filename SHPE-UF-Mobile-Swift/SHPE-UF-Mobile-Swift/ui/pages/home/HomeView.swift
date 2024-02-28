//
//  HomeView.swift
//  SHPE-UF-Mobile-Swift
//
//

import SwiftUI

struct Constants {
    
    static let BackgroundColor: Color = Color(red: 0.93, green: 0.93, blue: 0.93)
    static let DarkModeBackgroundColor: Color = Color(red: 0, green: 0.12, blue: 0.21)
    static let DescriptionHeaderColor: Color = Color(red: 0, green: 0.12, blue: 0.21)
    static let NotificationsSelectIcon: Color = Color(red: 0.72, green: 0.72, blue: 0.72)
    static let DescriptionTextColor: Color = Color(red: 0.25, green: 0.25, blue: 0.25)
    static let Orange: Color = Color(red: 0.82, green: 0.35, blue: 0.09)
    static let DashedLineColor: Color = .black
    static let DayTextColor: Color = Color(red: 0.42, green: 0.42, blue: 0.42)
    static let DayNumberTextColor: Color = Color(red: 0.26, green: 0.26, blue: 0.26)
    static let teal: Color = Color(red: 0.26, green: 0.46, blue: 0.48)
    static let grey: Color = Color(red: 0.23, green: 0.23, blue: 0.23)
    static let red : Color = Color(red: 0.63, green: 0, blue: 0)
    static let green : Color = Color(red: 0.17, green: 0.34, blue: 0.09)
    static let yellow : Color = Color(red: 0.69, green: 0.54, blue: 0)
    static let pink : Color = Color(red: 0.75, green: 0.29, blue: 0.51)
    
}

struct DateHelper {
    func getCurrentMonth() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter.string(from: Date())
    }
    // Formatting all the dates
    //Start and end times
    func getTime(for date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.string(from: date)
    }

    // For the full date of the event
    func getDayFull(for date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        return dateFormatter.string(from: date)
    }
    // For the date of the event next to the text bubble
    func getDayAbbreviation(for date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E"
        return dateFormatter.string(from: date)
    }

    func getDayNumber(for date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"
        return dateFormatter.string(from: date)
    }
   


}




struct HomeView: View {
    
    let dateHelper = DateHelper()
    @ObservedObject var viewModel = HomeViewModel()
    @State private var isNotificationButtonPagePresented = false
    
    
    var body: some View {
        NavigationView{
            VStack(spacing: 0) {
                // Orange Bar at the top of the screen with Month and Button
                ZStack {
                    Constants.Orange
                        .frame(height: 93)
                    HStack(spacing: 20) {
                        Text(dateHelper.getCurrentMonth())
                            .font(Font.custom("Viga", size: 24))
                            .foregroundColor(.white)
                            .frame(width: 107, height: 0, alignment: .topLeading)

                        
                        Spacer()
                        NavigationLink(destination: NotificationView()){
                               Image("Doorbell")
                                   .resizable()
                                   .aspectRatio(contentMode: .fit)
                                   .frame(width: 33, height: 32)
                                   .padding(.top, 20)
                            
                        }
                        
                        
                    }
                    .padding(.horizontal, 20)
                }
                
                //This is the scroll view with all the events
                ZStack{
                    ScrollView {
                        VStack(spacing: 20) {
                            
                           
                            
                            ForEach(viewModel.events.indices, id: \.self) { index in
                                
                                let event = viewModel.events[index]
                                let abrDateString = dateHelper.getDayAbbreviation(for: event.start.dateTime)
                                let numDateString = dateHelper.getDayNumber(for: event.start.dateTime)
                                
                                
                                HStack{
                                    if index == 0 || !sameDay(viewModel.events[index - 1], viewModel.events[index]){
                                        VStack(alignment: .center, spacing: 0) {
                                            Text(abrDateString)
                                                .font(Font.custom("UniversLTStd", size: 14))
                                                .multilineTextAlignment(.center)
                                                .foregroundColor(Constants.DayTextColor)
                                                .frame(width: 35, height: 15, alignment: .top)
                                            Text(numDateString)
                                                .font(Font.custom("UniversLTStd", size: 20))
                                                .multilineTextAlignment(.center)
                                                .foregroundColor(Constants.DayNumberTextColor)
                                                .frame(width: 26, height: 16, alignment: .top)
                                        }
                                        .padding(.horizontal, 2)
                                        .padding(.top, 4)
                                        .padding(.bottom, 8)
                                        .frame(width: 39, height: 45, alignment: .top)
                                        
                                        
                                    }else{
                                        VStack{
                                            
                                        }
                                        .padding(.horizontal, 2)
                                        .padding(.top, 4)
                                        .padding(.bottom, 8)
                                        .frame(width: 39, height: 45, alignment: .top)
                                    }
                                    
                                    
                                    NavigationLink(destination: eventInfo(event: viewModel.events[index])) {
                                           RectangleBox(event: viewModel.events[index])
                                               .frame(width: 324, height: 69)
                                    }
                                }
                                
                                
                                //Dashed Line
                                
                                if index != viewModel.events.indices.last && !sameDay(viewModel.events[index], viewModel.events[index + 1]) {
                                                                    Rectangle()
                                                                        .frame(width: 301, height: 1)
                                                                        .foregroundColor(.clear)
                                                                        .overlay(
                                                                            RoundedRectangle(cornerRadius: 1)
                                                                                .stroke(style: StrokeStyle(lineWidth: 1, dash: [4]))
                                                                                .foregroundColor(Constants.DashedLineColor)
                                                                        )
                                }   

                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                    }
                    .background(Constants.BackgroundColor)
                    .frame(maxWidth: .infinity)
                }
                
                
            }
            .background(Constants.BackgroundColor)
            .edgesIgnoringSafeArea(.all)
        }
     
        }
    func sameDay(_ event1: Event, _ event2: Event) -> Bool {
            let calendar = Calendar.current
            return calendar.isDate(event1.start.dateTime, inSameDayAs: event2.start.dateTime)
    }
        
}

struct eventInfo: View{
    var event:Event
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View{
        let dateHelper = DateHelper()
        // This is for the start and end time
       
        let startTimeString = dateHelper.getTime(for: event.start.dateTime)
        let endTimeString = dateHelper.getTime(for: event.end.dateTime)
        
        // For the date of the event
        let startdateString = dateHelper.getDayFull(for: event.start.dateTime)
        
        let (iconImage) = eventTypeVariables(event: event)
        ZStack {
            VStack{
                Rectangle()
                .foregroundColor(.clear)
                .frame(width: 466, height: 273)
                .background(
                //Dummy Image that needs to have more images
                Image("GBMimage")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 466, height: 273,alignment: .topLeading)
                .clipped()
                )
                Spacer()
              
            }
            
            VStack {
                
                HStack {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        ZStack {
                            Image("Ellipse_back")
                                .frame(width: 40, height: 40)
                            Image("Back")
                                .frame(width:40, height:70)
                        }
                    }
                    .padding(50)
                    Spacer()
                  
                }
               Spacer()
                
                ZStack{
                    Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 393, height: 550)
                    .background(Constants.BackgroundColor)
                    .cornerRadius(20)
                    VStack{
                        Spacer()
                        HStack{
                            Text(event.summary)
                            .bold()
                            .font(Font.custom("Viga", size: 32))
                            .foregroundColor(Constants.Orange)

                            .frame(width: 213, height: 120, alignment: .topLeading)
                            Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 37, height: 37)
                            .background(
                            Image(iconImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            )
                        }
                        .frame(width: 300, alignment: .leading)
                        Spacer()
                        HStack(spacing: 20){
                            
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(width: 37, height: 37)
                                .background(
                                    Image("Calendar")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                )
                            Text(startdateString)
                                .font(Font.custom("UniversLTStd", size: 18))
                                .foregroundColor(Constants.DescriptionTextColor)
                            
                        }
                        .frame(width: 300, alignment: .leading)
                        
                        HStack(spacing: 20){
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(width: 35, height: 34)
                                .background(
                                    Image("Timer")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                )
                            
                            Text("\(startTimeString) - \(endTimeString)")
                                .font(Font.custom("UniversLTStd", size: 18))
                                .foregroundColor(Constants.DescriptionTextColor)
                        }
                        .frame(width: 300, alignment: .leading)
                       
                        HStack(spacing: 20){
                            Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 34, height: 34)
                            .background(
                                Image("iconLocation")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                            )
                            //Dummy section, Location is not defined in google calendar
                            Text(String(event.location ?? "Reitz"))
                              .font(Font.custom("UniversLTStd", size: 18))
                              .foregroundColor(Constants.DescriptionTextColor)
                    
                        }
                        .frame(width: 300, alignment: .leading)
                        Spacer()
                        Text("Description:")
                        .font(Font.custom("UniversLTStd", size: 18))
                        .foregroundColor(Constants.DescriptionHeaderColor)
                        .frame(width: 300, alignment: .leading)
                        //Dummy  description
                        Text("Join us for our 1st Spring GBM next Wednesday for exciting annoucements, upcoming events, and free food!")
                          .font(Font.custom("UniversLTStd", size: 18))
                          .foregroundColor(Constants.DescriptionTextColor)
                          .frame(width: 297, alignment: .topLeading)
                        Spacer()
                    }
                }
                

            }
        }
        .frame(width: 393, height: 852)
        .background(Constants.BackgroundColor)
        .edgesIgnoringSafeArea(.all)
        .navigationBarHidden(true)
        
    }
    //Need the other orange icons
    //Dummy icons
    func eventTypeVariables(event: Event) -> (String) {
            switch event.eventType {
            case "GBM":
                return ( "iconGBM_Full")
            case "Workshop":
                return ("iconWorkShop_Full")
            case "Social":
                return ("iconSocial_Full")
            case "Volunteering":
                return ("Volunteering")
            case "Info":
                return ("Info")
            default:
                return ("Business_Group")
            }
        }
    
}


struct RectangleBox: View {
    var event: Event
    
    var body: some View {
        
        let dateHelper = DateHelper()
        // This is for the start and end time
       
        let startTimeString = dateHelper.getTime(for: event.start.dateTime)
        let endTimeString = dateHelper.getTime(for: event.end.dateTime)
        
        // For the date of the event
        let startdateString = dateHelper.getDayFull(for: event.start.dateTime)

        
        let (color, iconImage) = eventTypeVariables(event: event)
        
        if startTimeString == endTimeString {
           
            
            return AnyView(Group{
                    //Prints out events with  no set times
                ZStack {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 324, height: 69)
                        .background(color)
                        .cornerRadius(25)
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
                        .frame(width: 266, height: 17, alignment: .topLeading)
                        
                        
                        HStack(alignment: .center, spacing: 5) {
                            HStack{
                                Rectangle()
                                    .foregroundColor(.clear)
                                    .frame(width: 24, height: 24)
                                    .background(
                                        Image("Calendar")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                    )
                                Text(startdateString)
                                    .font(Font.custom("UniversLTStd", size: 12))
                                    .foregroundColor(.white)
                            }
                            .frame(width: 266, height: 17, alignment: .topLeading)
                            
                            
                            
                        }
                        .padding(0)
                    }
                    
                }
                
            })
                
        }else{
            return AnyView(
                Group{
                    
                        //Prints out events with set times
                    ZStack {
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 324, height: 69)
                            .background(color)
                            .cornerRadius(25)
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
                            .frame(width: 266, height: 17, alignment: .topLeading)
                            
                            
                            HStack(alignment: .center, spacing: 5) {
                                HStack{
                                    Rectangle()
                                        .foregroundColor(.clear)
                                        .frame(width: 24, height: 24)
                                        .background(
                                            Image("Calendar")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                        )
                                    Text(startdateString)
                                        .font(Font.custom("UniversLTStd", size: 12))
                                        .foregroundColor(.white)
                                }
                                .frame(width: 115, height: 17, alignment: .topLeading)
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
                            .padding(0)
                        }
                        
                    }
                }
                
            )
            
            
        }
    }
    func eventTypeVariables(event: Event) -> (Color, String) {
            switch event.eventType {
            case "GBM":
                return (Constants.grey, "Business_Group")
            case "Workshop":
                return (Constants.yellow, "Training")
            case "Social":
                return (Constants.red, "Users")
            case "Volunteering":
                return (Constants.green, "Volunteering")
            case "Info":
                return (Constants.teal, "Info")
            default:
                return (.clear, "Business_Group")
            }
        }
   
}




#Preview {
    HomeView()
}

