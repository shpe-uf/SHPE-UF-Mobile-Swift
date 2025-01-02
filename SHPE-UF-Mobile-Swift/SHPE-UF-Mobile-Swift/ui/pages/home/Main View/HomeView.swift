//home view
//
import SwiftUI
import CoreData

struct HomeView: View {
    //Variables for the view model
    @Environment(\.colorScheme) var colorScheme // Detects the system's color scheme (dark or light mode)
    let dateHelper = DateHelper()
    @State private var displayedMonth: String = ""
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: []) private var coreEvents: FetchedResults<CalendarEvent>
    @StateObject var viewModel:HomeViewModel
    @StateObject var appVM:AppViewModel = AppViewModel.appVM
        
    @State private var offset: CGFloat = 0
    @State private var isDragging = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Top bar with the current month and notification icon
            ZStack {
                Constants.orange
                    .frame(width: UIScreen.main.bounds.width, height: 100)
                HStack(spacing: 20) {
                    // Displaying the current month
                    Text(displayedMonth)
                        .font(Font.custom("Viga-Regular", size: 24))
                        .foregroundColor(.white)
                        .frame(height: 0, alignment: .topLeading)
                    
                    Spacer()
                    // Navigation link to the notification view
                    Button {
                        // Dismiss the current view when the button is pressed
                        appVM.showView = "NotificationView"
                    } label: {
                        // Button label with an image
                        Image("Doorbell")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 33, height: 32, alignment: .topLeading)
                            .padding(.top, UIScreen.main.bounds.width * 0.05)
                    }
                    .padding(.top, 10)
                }
                .padding(.horizontal, UIScreen.main.bounds.width * 0.05)
            }

            // Main content area
            ZStack{
                if (viewModel.getUpcomingEvents().isEmpty)
                {
                    Text("No Upcoming Events...")
                        .multilineTextAlignment(.center)
                        .font(Font.custom("Viga-Regular", size: 40))
                        .foregroundStyle(Color.gray.opacity(0.5))
                }
                ScrollView {
                    ScrollViewReader { proxy in
                        LazyVStack(spacing: 20) {
                            // Loop through events and display them
                            ForEach(viewModel.getUpcomingEvents().indices, id: \.self)
                            { index in
                                let upcomingEvents = viewModel.getUpcomingEvents()
                                let event = upcomingEvents[index]
                                let abrDateString = dateHelper.getDayAbbreviation(for: event.start.dateTime)
                                let numDateString = dateHelper.getDayNumber(for: event.start.dateTime)
                                
                                // Event row with date and event details
                                HStack {
                                    // Display date only for the first event or when the day changes
                                    if index == 0 || !sameDay(upcomingEvents[index - 1], upcomingEvents[index]) {
                                        
                                        
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
                                        .frame(width: 39, height: 45, alignment: .top)
                                        .padding(.horizontal, 2)
                                        .padding(.top, 4)
                                        .padding(.bottom, 8)
                                        .padding(.trailing, 10)
                                        
                                    } else {
                                        VStack { }
                                            .frame(width: 39, height: 45, alignment: .top)
                                            .padding(.horizontal, 2)
                                            .padding(.top, 4)
                                            .padding(.bottom, 8)
                                    }
                                    
                                    // Navigation link to detailed event information
                                    Button {
                                        // Dismiss the current view when the button is pressed
                                        withAnimation(.easeInOut(duration: 0.2))
                                        {
                                            appVM.showView = "EventView"
                                            appVM.currentEventIndex = index
                                        }
                                    } label: {
                                        // Button label with an image
                                        EventBox(event: upcomingEvents[index])
                                            .frame(width: UIScreen.main.bounds.width * 0.75, height: 69)
                                            .background(
                                                GeometryReader { geometry in
                                                    Color.clear
                                                        .onChange(of: geometry.frame(in: .global).maxY) {
                                                            // Check if the event box is about to move out of view
                                                            if geometry.frame(in: .global).maxY < UIScreen.main.bounds.height * 0.1 {
                                                                // Get the index of the next event
                                                                let nextEventIndex = min(index + 2, upcomingEvents.count - 1)
                                                                // Update displayed month based on the next event
                                                                displayedMonth = dateHelper.getMonth(for: upcomingEvents[nextEventIndex].start.dateTime)
                                                            }
                                                            else
                                                            {
                                                                let priorEventIndex = max(index - 2, 0)
                                                                // Update displayed month based on the next event
                                                                displayedMonth = dateHelper.getMonth(for: upcomingEvents[priorEventIndex].start.dateTime)
                                                            }
                                                        }
                                                }
                                            )
                                    }
                                }
                               
                                
                                // Dashed line separator for events on different days
                                if index != upcomingEvents.indices.last && !sameDay(upcomingEvents[index], upcomingEvents[index + 1]) {
                                    HStack{
                                        Rectangle()
                                            .foregroundColor(.clear)
                                            .frame(width: 39, height: 1, alignment: .top)
                                        Rectangle()
                                            .frame(width: UIScreen.main.bounds.width * 0.75, height: 1, alignment: .center)
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
                        .padding(.trailing, 20)
                    }
                    .background(colorScheme == .dark ? Constants.darkModeBackground : Constants.BackgroundColor)
                    .frame(maxWidth: .infinity)
                    .onAppear {
                        // Initialize lastUpdatedVisibleMonths with initial visible months
                        displayedMonth = dateHelper.getCurrentMonth()
                        NotificationViewModel.instance.pendingNotifications = CoreFunctions().mapCoreEventToEvent(events: coreEvents, viewContext: viewContext)

                    }
                }
            }
        }
        .background(colorScheme == .dark ? Constants.darkModeBackground : Constants.BackgroundColor)
        .edgesIgnoringSafeArea(.all)
        .overlay {
            Group
            {
                if appVM.showView == "NotificationView"
                {
                    NotificationView(viewModel: viewModel, showView: $appVM.showView)
                }
                else if appVM.showView == "EventView"
                {
                    EventInfoView(event: viewModel.getUpcomingEvents()[appVM.currentEventIndex ?? 0], showView: $appVM.showView)
                        .transition(.move(edge: .trailing))
                } else if appVM.showView == "LocationView"
                {
                    LocationView(location: viewModel.getUpcomingEvents()[appVM.currentEventIndex ?? 0].location ?? "Unknown",event: viewModel.getUpcomingEvents()[appVM.currentEventIndex ?? 0].summary, showView: $appVM.showView)
                        .transition(.move(edge: .trailing))
                        .environment(LocationManager())
                }

            }
            .offset(x:offset)
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        if appVM.showView == "LocationView" { return }
                           
                        isDragging = true
                        offset = gesture.translation.width > 0 ? gesture.translation.width : 0
                    }
                    .onEnded { _ in
                        isDragging = false
                        if offset > 100
                        {
                            withAnimation(.easeInOut(duration: appVM.showView == "EventView" ? 0.5 : 0.2))
                            {
                                appVM.showView = ""
                            }
                        }
                        withAnimation(.easeOut(duration: 0.2))
                        {
                            offset = 0
                        }
                    }
            )
            .animation(.easeInOut, value: offset)
        }
    }
            
    
    // Helper function to check if two events occur on the same day
    func sameDay(_ event1: Event, _ event2: Event) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(event1.start.dateTime, inSameDayAs: event2.start.dateTime)
    }
}


