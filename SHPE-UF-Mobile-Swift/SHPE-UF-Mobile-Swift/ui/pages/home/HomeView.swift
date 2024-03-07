//home view
//
import SwiftUI

struct Constants {
    static let BackgroundColor: Color = Color(red: 0.93, green: 0.93, blue: 0.93) // Default background color
    static let darkModeBackground: Color = Color(red: 0, green: 0, blue: 0.2) // Dark blue for dark mode
    static let DescriptionHeaderColor: Color = Color(red: 0, green: 0.12, blue: 0.21) // Color for headers in descriptions
    static let lightTextColor: Color = Color.white // Text color for dark mode
    static let NotificationsSelectIcon: Color = Color(red: 0.72, green: 0.72, blue: 0.72) // Color for notification icons
    static let DescriptionTextColor: Color = Color(red: 0.25, green: 0.25, blue: 0.25) // Color for text in descriptions
    static let DashedLineColor: Color = Color.black // Color for dashed lines
    static let DayTextColor: Color = Color(red: 0.42, green: 0.42, blue: 0.42) // Text color for days
    static let DayNumberTextColor: Color = Color(red: 0.26, green: 0.26, blue: 0.26) // Text color for day numbers
    static let orange: Color = Color(red: 0.82, green: 0.35, blue: 0.09) // Custom orange color
    static let teal: Color = Color(red: 0.26, green: 0.46, blue: 0.48) // Custom teal color
    static let blue: Color = Color(red: 0, green: 0.44, blue: 0.76) // Custom blue color
    static let grey: Color = Color(red: 0.23, green: 0.23, blue: 0.23) // Custom grey color
    static let green: Color = Color(red: 0.17, green: 0.34, blue: 0.09) // Custom green color
    static let yellow: Color = Color(red: 0.69, green: 0.54, blue: 0) // Custom yellow color
    static let pink: Color = Color(red: 0.75, green: 0.29, blue: 0.51) // Custom pink color
    static let iconColor: Color = Color.black // Icon color for light mode
    static let darkModeIcon: Color = Color.white // Icon color for dark mode
}

struct DateHelper {
    // Gets the current month as a string
    func getCurrentMonth() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter.string(from: Date())
    }

    // Gets the time in hour and minutes AM/PM format
    func getTime(for date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.string(from: date)
    }

    // Gets the full date format for an event
    func getDayFull(for date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        return dateFormatter.string(from: date)
    }

    // Gets the day abbreviation (e.g., Mon, Tue)
    func getDayAbbreviation(for date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E"
        return dateFormatter.string(from: date)
    }

    // Gets the day number from a date
    func getDayNumber(for date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"
        return dateFormatter.string(from: date)
    }
}

struct HomeView: View {
    @Environment(\.colorScheme) var colorScheme // Detects the system's color scheme (dark or light mode)
    let dateHelper = DateHelper() // Date helper instance for manipulating dates
    @ObservedObject var viewModel = HomeViewModel() // ViewModel for managing the view's state
    @State private var isNotificationButtonPagePresented = false // State for managing notification button presentation

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Top bar with the current month and notification icon
                ZStack {
                    Constants.orange
                        .frame(height: 93)
                    HStack(spacing: 20) {
                        // Displaying the current month
                        Text(dateHelper.getCurrentMonth())
                            .font(Font.custom("Viga", size: 24))
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
                ZStack {
                    ScrollView {
                        VStack(spacing: 20) {
                            // Loop through events and display them
                            ForEach(viewModel.events.indices, id: \.self) { index in
                                let event = viewModel.events[index]
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
                                        RectangleBox(event: viewModel.events[index])
                                            .frame(width: 324, height: 69)
                                    }
                                }
                                
                                // Dashed line separator for events on different days
                                if index != viewModel.events.indices.last && !sameDay(viewModel.events[index], viewModel.events[index + 1]) {
                                    Rectangle()
                                        .frame(width: 301, height: 1)
                                        .foregroundColor(.clear)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 1)
                                                .stroke(style: StrokeStyle(lineWidth: 1, dash: [4]))
                                                .foregroundColor(colorScheme == .dark ? Constants.lightTextColor : Constants.DashedLineColor)
                                        )
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
            .background(colorScheme == .dark ? Constants.darkModeBackground : Constants.BackgroundColor)
            .edgesIgnoringSafeArea(.all)
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
                    .background(Constants.BackgroundColor)
                    .cornerRadius(20)
                    VStack{
                        Spacer(minLength: 75)
                        // Event title and icon
                        HStack{
                            Text(event.summary)
                            .bold()
                            .font(Font.custom("Viga", size: 32))
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
                                .foregroundColor(Constants.DescriptionTextColor)
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
                                .foregroundColor(Constants.DescriptionTextColor)
                        }
                        .frame(width: 300, alignment: .leading)
                       
                        // Event location (dummy for demonstration)
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
                              .foregroundColor(Constants.DescriptionTextColor)
                        }
                        .frame(width: 300, alignment: .leading)
                        Spacer(minLength: 60)
                        // Event description header
                        Text("Description:")
                        .font(Font.custom("UniversLTStd", size: 18))
                        .foregroundColor(Constants.DescriptionHeaderColor)
                        .frame(width: 300, alignment: .leading)
                        .padding(10)
                        // Event description text
                        Text("Join us for our 1st Spring GBM next Wednesday for exciting announcements, upcoming events, and free food!")
                          .font(Font.custom("UniversLTStd", size: 18))
                          .foregroundColor(Constants.DescriptionTextColor)
                          .frame(width: 297,height: 200, alignment: .topLeading)
                       
                        Spacer(minLength: 30)
                    }
                }
            }
        }
        .frame(width: 393, height: 852)
        .background(Constants.BackgroundColor)
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


struct RectangleBox: View {
    var event: Event
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        let dateHelper = DateHelper()
        let startTimeString = dateHelper.getTime(for: event.start.dateTime)
        let endTimeString = dateHelper.getTime(for: event.end.dateTime)
        let startdateString = dateHelper.getDayFull(for: event.start.dateTime)
        let (color, iconImage) = eventTypeVariables(event: event)
        
        // Use the colorScheme to determine text and icon colors
        let textColor = colorScheme == .dark ? Constants.lightTextColor : Color.white
        let iconName = colorScheme == .dark ? iconImage + "_white" : iconImage
        
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


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .preferredColorScheme(.light) // For light mode preview
        HomeView()
            .preferredColorScheme(.dark) // For dark mode preview
    }
}

#Preview {
    HomeView()
}
