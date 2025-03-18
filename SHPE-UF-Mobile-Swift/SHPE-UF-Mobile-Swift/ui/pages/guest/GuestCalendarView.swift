import SwiftUI
import CoreData

struct GuestCalendarView: View {
    @FetchRequest(sortDescriptors: []) private var coreEvents: FetchedResults<CalendarEvent>
    @Environment(\.managedObjectContext) private var viewContext
    // ViewModel
    @StateObject var viewModel: HomeViewModel
    @StateObject var appVM: AppViewModel = AppViewModel.appVM
    let dateHelper = DateHelper()

    @Environment(\.colorScheme) var colorScheme
    @State private var displayedMonth: String = ""
    @State private var offset: CGFloat = 0
    @State private var isDragging = false

    var body: some View {
        VStack(spacing: 0) {
            // Top bar with the current month and Login icon
            ZStack(alignment: .center) {
                Constants.orange
                    .frame(width: UIScreen.main.bounds.width, height: 100)
                HStack(spacing: 20) {
                    Text(displayedMonth)
                        .font(Font.custom("Viga-Regular", size: 24))
                        .foregroundColor(.white)
                        .frame(height: 0, alignment: .topLeading)

                    Spacer()
                    //Navigate to login page
                    Button(action: {
                        appVM.setPageIndex(index: 0)
                    }) {
                        HStack {
                            Text("Login")
                                .font(Font.custom("UniversLTStd", size: 20))
                                .foregroundColor(.white)
                                
                            Image("Login")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 20, height: 20)
                                .foregroundColor(.white)

                        }
                        
                    }
                    .padding(.top, 10)
                    .frame(height: 0, alignment: .topLeading)
                    
                }
                .padding(.horizontal, UIScreen.main.bounds.width * 0.05)
                
            }
            
            // Main content area
            ZStack {
                if viewModel.getUpcomingEvents().isEmpty {
                    
                    Text("No Upcoming Events...")
                        .multilineTextAlignment(.center)
                        .font(Font.custom("Viga-Regular", size: 40))
                        .foregroundColor(Color.gray.opacity(0.5))
                    Spacer()
                }
                
                ScrollView {
                    ScrollViewReader { proxy in
                        LazyVStack(spacing: 20) {
                            let upcomingEvents = viewModel.getUpcomingEvents()
                            ForEach(upcomingEvents.indices, id: \.self) { index in
                                let event = upcomingEvents[index]
                                
                                // Decide whether to show day heading
                                HStack {
                                    if index == 0
                                       || !sameDay(upcomingEvents[index - 1], upcomingEvents[index]) {
                                        
                                        // Show date heading (like "Mon" + "16")
                                        VStack(alignment: .center, spacing: 0) {
                                            Text(dateHelper.getDayAbbreviation(for: event.start.dateTime))
                                                .font(Font.custom("UniversLTStd", size: 14))
                                                .multilineTextAlignment(.center)
                                                .foregroundColor(colorScheme == .dark
                                                                 ? Constants.lightTextColor : Constants.DayTextColor)
                                                .frame(width: 35, height: 15, alignment: .top)
                                            
                                            Text(dateHelper.getDayNumber(for: event.start.dateTime))
                                                .font(Font.custom("UniversLTStd", size: 20))
                                                .multilineTextAlignment(.center)
                                                .foregroundColor(colorScheme == .dark
                                                                 ? Constants.lightTextColor : Constants.DayNumberTextColor)
                                                .frame(width: 26, height: 16, alignment: .top)
                                        }
                                        .frame(width: 39, height: 45, alignment: .top)
                                        .padding(.horizontal, 2)
                                        .padding(.top, 4)
                                        .padding(.bottom, 8)
                                        .padding(.trailing, 10)
                                    } else {
                                        // If same day as previous event, just show empty space
                                        VStack { }
                                            .frame(width: 39, height: 45)
                                            .padding(.horizontal, 2)
                                            .padding(.top, 4)
                                            .padding(.bottom, 8)
                                    }
                                    
                                    // ── The event button ──
                                    Button {
                                        withAnimation {
                                            appVM.showView = "EventView"
                                            appVM.currentEventIndex = index
                                        }
                                    } label: {
                                        EventBox(event: event)
                                            .frame(width: UIScreen.main.bounds.width * 0.75, height: 69)
                                            .background(
                                                GeometryReader { geometry in
                                                    Color.clear
                                                        .onChange(of: geometry.frame(in: .global).maxY) { yPos in
                                                            // This logic updates displayedMonth if the card scrolls near the top
                                                            if yPos < UIScreen.main.bounds.height * 0.1 {
                                                                let nextIndex = min(index + 2, upcomingEvents.count - 1)
                                                                displayedMonth = dateHelper.getMonth(for: upcomingEvents[nextIndex].start.dateTime)
                                                            } else {
                                                                let prevIndex = max(index - 2, 0)
                                                                displayedMonth = dateHelper.getMonth(for: upcomingEvents[prevIndex].start.dateTime)
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
                        displayedMonth = dateHelper.getCurrentMonth()
                    }
                }
                
            }
           
        }
        .background(colorScheme == .dark ? Constants.darkModeBackground : Constants.BackgroundColor)
        .edgesIgnoringSafeArea(.all) // Put it here
        .overlay {
            Group {
                    if appVM.showView == "EventView" {
                        EventInfoView(event: viewModel.getUpcomingEvents()[appVM.currentEventIndex ?? 0], showView: $appVM.showView)
                            .transition(.move(edge: .trailing))
                    } else if appVM.showView == "LocationView" {
                        LocationView(
                            location: viewModel.getUpcomingEvents()[appVM.currentEventIndex ?? 0].location ?? "Unknown",
                            event: viewModel.getUpcomingEvents()[appVM.currentEventIndex ?? 0].summary,
                            showView: $appVM.showView
                        )
                        .transition(.move(edge: .trailing))
                    }
                }
                .offset(x: offset)
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            if appVM.showView == "LocationView" { return }
                            isDragging = true
                            offset = gesture.translation.width > 0 ? gesture.translation.width : 0
                        }
                        .onEnded { _ in
                            isDragging = false
                            if offset > 100 {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    appVM.showView = ""
                                }
                            }
                            withAnimation(.easeOut(duration: 0.2)) {
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
