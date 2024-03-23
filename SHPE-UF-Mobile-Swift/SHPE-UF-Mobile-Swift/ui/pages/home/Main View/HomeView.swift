//home view
//
import SwiftUI

struct HomeView: View {
    //Variables for the view model
    @Environment(\.colorScheme) var colorScheme // Detects the system's color scheme (dark or light mode)
    let dateHelper = DateHelper()
    @ObservedObject var viewModel = HomeViewModel()
    @State private var isNotificationButtonPagePresented = false
    @State private var displayedMonth: String = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Top bar with the current month and notification icon
                ZStack {
                    Constants.orange
                        .frame(height: 93)
                    HStack(spacing: 20) {
                        // Displaying the current month
                        Text(displayedMonth)
                            .font(Font.custom("Viga-Regular", size: 24))
                            .foregroundColor(.white)
                            .frame(width: 107, height: 0, alignment: .topLeading)
                        
                        Spacer()
                        // Navigation link to the notification view
                        NavigationLink(destination: NotificationView()) {
                            Image("Doorbell")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 33, height: 32)
                                .padding(.top, 20)
                        }
                    }
                    .padding(.horizontal, 20)
                }

                // Main content area
                ZStack{
                    ScrollView {
                        ScrollViewReader { proxy in
                            LazyVStack(spacing: 20) {
                                // Loop through events and display them
                                ForEach(viewModel.events.indices, id: \.self) { index in
                                    let event = viewModel.events[index]
                                    let currentMonth = dateHelper.getMonth(for: event.start.dateTime)
                                    let abrDateString = dateHelper.getDayAbbreviation(for: event.start.dateTime)
                                    let numDateString = dateHelper.getDayNumber(for: event.start.dateTime)
                                    
                                    // Event row with date and event details
                                    HStack {
                                        // Display date only for the first event or when the day changes
                                        if index == 0 || !sameDay(viewModel.events[index - 1], viewModel.events[index]) {
                                            
                                            
                                            VStack(alignment: .center, spacing: 0) {
                                                Text(abrDateString)
                                                    .font(Font.custom("UniversLTStd", size: 14))
                                                    .multilineTextAlignment(.center)
                                                    .foregroundColor(colorScheme == .dark ? Constants.lightTextColor : Constants.DayTextColor)
                                                    .frame(width: 35, height: 15, alignment: .top)
                                                Text(numDateString)
                                                    .font(Font.custom("UniversLTStd", size: 20))
                                                    .multilineTextAlignment(.center)
                                                    .foregroundColor(colorScheme == .dark ? Constants.lightTextColor : Constants.DayNumberTextColor)
                                                    .frame(width: 26, height: 16, alignment: .top)
                                            }
                                            .padding(.horizontal, 2)
                                            .padding(.top, 4)
                                            .padding(.bottom, 8)
                                            .frame(width: 39, height: 45, alignment: .top)
                                        } else {
                                            VStack { }
                                                .padding(.horizontal, 2)
                                                .padding(.top, 4)
                                                .padding(.bottom, 8)
                                                .frame(width: 39, height: 45, alignment: .top)
                                        }
                                        
                                        // Navigation link to detailed event information
                                        NavigationLink(destination: eventInfo(event: viewModel.events[index])) {
                                            eventBox(event: viewModel.events[index])
                                                .frame(width: 324, height: 69)
                                                .background(
                                                    GeometryReader { geometry in
                                                        Color.clear
                                                            .onChange(of: geometry.frame(in: .global).maxY) {
                                                                // Check if the event box is about to move out of view
                                                                if geometry.frame(in: .global).maxY < UIScreen.main.bounds.height * 0.1 {
                                                                    // Get the index of the next event
                                                                    let nextEventIndex = min(index + 2, viewModel.events.count - 1)
                                                                    // Update displayed month based on the next event
                                                                    displayedMonth = dateHelper.getMonth(for: viewModel.events[nextEventIndex].start.dateTime)
                                                                }
                                                            }
                                                    }
                                                )
                                            
                                        }
                                    }
                                   
                                    
                                    // Dashed line separator for events on different days
                                    if index != viewModel.events.indices.last && !sameDay(viewModel.events[index], viewModel.events[index + 1]) {
                                        HStack{
                                            Rectangle()
                                                .foregroundColor(.clear)
                                                .frame(width: 39, height: 1, alignment: .top)
                                            Rectangle()
                                                .frame(width: 301, height: 1, alignment: .center)
                                                .foregroundColor(.clear)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 1)
                                                        .stroke(style: StrokeStyle(lineWidth: 1, dash: [4]))
                                                        .foregroundColor(colorScheme == .dark ? Constants.lightTextColor : Constants.DashedLineColor)
                                                )
                                        }
                                        
                                    }
                                }
                            }
                            .padding(.bottom, 100)
                            .padding()
                            .frame(maxWidth: .infinity)
                        }
                        .background(colorScheme == .dark ? Constants.darkModeBackground : Constants.BackgroundColor)
                        .frame(maxWidth: .infinity)
                    }
                }
            }
            .background(colorScheme == .dark ? Constants.darkModeBackground : Constants.BackgroundColor)
            .edgesIgnoringSafeArea(.all)
        }
        .onAppear {
            // Initialize lastUpdatedVisibleMonths with initial visible months
            displayedMonth = dateHelper.getCurrentMonth()
        }
    }
    
    // Helper function to check if two events occur on the same day
    func sameDay(_ event1: Event, _ event2: Event) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(event1.start.dateTime, inSameDayAs: event2.start.dateTime)
    }
}

struct eventInfo: View {
    var event: Event // The event to display information for
    @Environment(\.presentationMode) var presentationMode // For dismissing the view
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        let dateHelper = DateHelper()
        let startTimeString = dateHelper.getTime(for: event.start.dateTime) // Event start time
        let endTimeString = dateHelper.getTime(for: event.end.dateTime) // Event end time
        let startdateString = dateHelper.getDayFull(for: event.start.dateTime) // Full start date of the event
        
        let (iconImage, eventImage) = eventTypeVariables(event: event) // Icons based on the event type
        ZStack {
            VStack {
                Rectangle()
                .foregroundColor(.clear)
                .frame(width: 466, height: 273)
                .background(
                Image(eventImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 466, height: 273,alignment: .topLeading)
                .clipped()
                )
                Spacer()
            }
            
            VStack {
                // Back button
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
                
                // Event information card
                ZStack{
                    Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 393, height: 550)
                    .background(colorScheme == .dark ? Constants.darkModeBackground : Constants.BackgroundColor)
                    .cornerRadius(20)
                    VStack{
                        Spacer(minLength: 75)
                        // Event title and icon
                        HStack{
                            Text(event.summary)
                            .bold()
                            .font(Font.custom("Viga-Regular", size: 32))
                            .foregroundColor(Constants.orange)
                            .frame(width:270, alignment: .topLeading)
                            .lineLimit(3)
                            Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 37, height: 37)
                            .background(
                            Image(iconImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            )
                        }
                        .frame(height: 130, alignment: .leading)
                        .padding(.horizontal, 20)
                        Spacer(minLength: 10)
                        // Event date
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
                                .foregroundColor(colorScheme == .dark ? Constants.lightTextColor : Constants.DayNumberTextColor)
                        }
                        .frame(width: 300, alignment: .leading)
                        
                        // Event time
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
                                .foregroundColor(colorScheme == .dark ? Constants.lightTextColor : Constants.DayNumberTextColor)
                        }
                        .frame(width: 300, alignment: .leading)
                       
                        // Event location 
                        HStack(spacing: 20){
                            Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 34, height: 34)
                            .background(
                                Image("iconLocation")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                            )
                            Text(String(event.location ?? "Reitz Union Ballroom"))
                              .font(Font.custom("UniversLTStd", size: 18))
                              .foregroundColor(colorScheme == .dark ? Constants.lightTextColor : Constants.DayNumberTextColor)
                        }
                        .frame(width: 300, alignment: .leading)
                        Spacer(minLength: 60)
                        // Event description header
                        Text("Description:")
                        .font(Font.custom("UniversLTStd", size: 18))
                        .foregroundColor(colorScheme == .dark ? Constants.teal : Constants.DescriptionHeaderColor)
                        .frame(width: 300, alignment: .leading)
                        .padding(10)
                        // Event description text
                        //Need to have event  description variables in the future
                        Text("")
                          .font(Font.custom("UniversLTStd", size: 18))
                          .foregroundColor(colorScheme == .dark ? Constants.lightTextColor : Constants.DayNumberTextColor)
                          .frame(width: 297,height: 200, alignment: .topLeading)
                       
                        Spacer(minLength: 30)
                    }
                }
            }
        }
        .frame(width: 393, height: 852)
        .background(colorScheme == .dark ? Constants.darkModeBackground : Constants.BackgroundColor)
        .edgesIgnoringSafeArea(.all)
        .navigationBarHidden(true)
        
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


struct eventBox: View {
    var event: Event
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        let dateHelper = DateHelper()
        let startTimeString = dateHelper.getTime(for: event.start.dateTime)
        let endTimeString = dateHelper.getTime(for: event.end.dateTime)
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
                
                
            }    }
    
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


#Preview {
    HomeView()
}
