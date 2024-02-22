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
  
//    let eventColors = [Constants.teal,Constants.grey,Constants.red,Constants.green,Constants.yellow, Constants.pink]
//    var eventColors = ["GBM":Constants.grey, ]
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
                
                
                ZStack{
                    ScrollView {
                        VStack(spacing: 20) {
                            ForEach(viewModel.events, id: \.id) { event in
                                                    RectangleBox(event: event)
                                                        .frame(width: 324, height: 69)
                                                    //Dashed Line
                                                    Rectangle()
                                                        .foregroundColor(.clear)
                                                        .frame(width: 301, height: 1)
                                                        .background(Constants.DashedLineColor)
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
        
}



struct RectangleBox: View {
    var event: Event
    
//    var color : Color
    
    var body: some View {
        let dateHelper = DateHelper()
        // This is for the start and end time
       
        let startTimeString = dateHelper.getTime(for: event.start.dateTime)
        let endTimeString = dateHelper.getTime(for: event.end.dateTime)
        
        // For the date of the event
        let startdateString = dateHelper.getDayFull(for: event.start.dateTime)
        
        let abrDateString = dateHelper.getDayAbbreviation(for: event.start.dateTime)
        let numDateString = dateHelper.getDayNumber(for: event.start.dateTime)
        
        
        
        if startTimeString == endTimeString {
           
            
            return AnyView(Group{
                HStack{
                    VStack(alignment: .center, spacing: 0) {
                        Text(abrDateString)
                            .font(Font.custom("Univers LT Std", size: 14))
                            .multilineTextAlignment(.center)
                            .foregroundColor(Constants.DayTextColor)
                            .frame(width: 35, height: 15, alignment: .top)
                        Text(numDateString)
                            .font(Font.custom("Univers LT Std", size: 20))
                            .multilineTextAlignment(.center)
                            .foregroundColor(Constants.DayNumberTextColor)
                            .frame(width: 26, height: 16, alignment: .top)
                    }
                    .padding(.horizontal, 2)
                    .padding(.top, 4)
                    .padding(.bottom, 8)
                    .frame(width: 39, height: 45, alignment: .top)
                    
                    ZStack {
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 324, height: 69)
        //                    .background(color)
                            .background(Constants.grey)
                            .cornerRadius(25)
                        VStack{
                            HStack{
                                Text(event.summary)
                                    .font(Font.custom("Univers LT Std", size: 15))
                                    .foregroundColor(.white)
                                    .frame(alignment: .topLeading)
                                Rectangle()
                                    .foregroundColor(.clear)
                                    .frame(width: 20, height: 20)
                                    .background(
                            
                                        Image("Business_Group")
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
                                        .font(Font.custom("Univers LT Std", size: 12))
                                        .foregroundColor(.white)
                                }
                                .frame(width: 266, height: 17, alignment: .topLeading)
                                
                                
                                
                            }
                            .padding(0)
                        }
                        
                    }
                }
            })
                
        }else{
            return AnyView(
                Group{
                    HStack{
                        VStack(alignment: .center, spacing: 0) {
                            Text(abrDateString)
                                .font(Font.custom("Univers LT Std", size: 14))
                                .multilineTextAlignment(.center)
                                .foregroundColor(Constants.DayTextColor)
                                .frame(width: 35, height: 15, alignment: .top)
                            Text(numDateString)
                                .font(Font.custom("Univers LT Std", size: 20))
                                .multilineTextAlignment(.center)
                                .foregroundColor(Constants.DayNumberTextColor)
                                .frame(width: 26, height: 16, alignment: .top)
                        }
                        .padding(.horizontal, 2)
                        .padding(.top, 4)
                        .padding(.bottom, 8)
                        .frame(width: 39, height: 45, alignment: .top)
                        
                        ZStack {
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(width: 324, height: 69)
                            //                    .background(color)
                                .background(Constants.grey)
                                .cornerRadius(25)
                            VStack{
                                HStack{
                                    Text(event.summary)
                                        .font(Font.custom("Univers LT Std", size: 15))
                                        .foregroundColor(.white)
                                    
                                        .frame(alignment: .topLeading)
                                    Rectangle()
                                        .foregroundColor(.clear)
                                        .frame(width: 20, height: 20)
                                        .background(
                                            
                                            Image("Business_Group")
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
                                            .font(Font.custom("Univers LT Std", size: 12))
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
                                            .font(Font.custom("Univers LT Std", size: 12))
                                            .foregroundColor(.white)
                                    }
                                    .frame(height: 17, alignment: .topLeading)
                                    
                                    
                                }
                                .padding(0)
                            }
                            
                        }
                    }
                }
            )
            
            
        }
    }
}




#Preview {
    HomeView()
}

