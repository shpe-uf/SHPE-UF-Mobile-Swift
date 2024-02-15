//
//  HomeView.swift
//  SHPE-UF-Mobile-Swift
//
//

import SwiftUI

struct Constants {
    static let BackgroundColor: Color = Color(red: 0.93, green: 0.93, blue: 0.93)
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



struct HomeView: View {
    let texts = ["SHPE Conference", "SHPE GBM 1", "SHPE GBM 2", "SHPE GBM 3", "SHPE GBM 4", "SHPE GBM 5", "SHPE GBM 6", "SHPE GBM 7", "SHPE GBM 8", "SHPE GBM 9", "SHPE GBM 10"]
    let eventColors = [Constants.teal,Constants.grey,Constants.red,Constants.green,Constants.yellow, Constants.pink]
    @ObservedObject var viewModel = HomeViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            // Orange bar at the top with current month and notification button
            ZStack {
                Constants.Orange
                    .frame(height: 93)
                HStack(spacing: 20) {
                    Text("January")
                        .font(Font.custom("Viga", size: 24))
                        .foregroundColor(.white)
                    Spacer()
                    Button(action: {
                        // Action for notification button
                    }) {
                        Image("Doorbell")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 33, height: 32)
                    }
                }
                .padding(.horizontal, 20) // Add padding to the HStack
            }
            
            // Scrollable rectangle boxes of text
            ScrollView {
                VStack(spacing: 20) {
//                    ForEach(Array(texts.enumerated()), id: \.element) { index, text in
//                           RectangleBox(text: text, color: eventColors[index % eventColors.count])
//                               .frame(width: 324, height: 69)
//                           
//                           //Dashed Line
//                           Rectangle()
//                               .foregroundColor(.clear)
//                               .frame(width: 301, height: 1)
//                               .background(Constants.DashedLineColor)
//                       }
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
            }
            .background(Constants.BackgroundColor)
            
        }
        .background(Constants.BackgroundColor)
        .edgesIgnoringSafeArea(.all)
    }
}


struct RectangleBox: View {
    var event: Event
//    var color : Color
    var body: some View {
        HStack{
            VStack(alignment: .center, spacing: 0) {
                Text("Mon")
                    .font(Font.custom("Univers LT Std", size: 14))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Constants.DayTextColor)
                    .frame(width: 35, height: 15, alignment: .top)
                Text("1")
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
                            .font(Font.custom("Univers LT Std", size: 16))
                            .foregroundColor(.white)
                        
                            .frame(width: 266, height: 17, alignment: .topLeading)
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 20, height: 20)
                            .background(
                                Image("Business_Group")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            )
                    }
                    
                    
                    HStack(alignment: .center, spacing: 5) {
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 24, height: 24)
                            .background(
                                Image("Calendar")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            )
                        Text("Jan 2nd, 2024")
                            .font(Font.custom("Univers LT Std", size: 12))
                            .foregroundColor(.white)
                        
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 24, height: 24)
                            .background(
                                Image("Timer")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            )
                        Text(event.start.timeZone)
                            .font(Font.custom("Univers LT Std", size: 12))
                            .foregroundColor(.white)
                    }
                    .padding(0)
                }
                
            }
        }
    }
}




#Preview {
    HomeView()
}

