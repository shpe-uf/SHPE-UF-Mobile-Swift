//home view
//
import SwiftUI
import CoreData
import MapKit

/// The primary view displaying upcoming events in a scrollable list.
///
/// This view:
/// 1. Shows a monthly calendar-style event list
/// 2. Handles navigation to event details and notifications
/// 3. Supports swipe gestures for navigation
/// 4. Adapts to light/dark mode
///
/// ## Key Features
/// - Dynamic month header that updates during scroll
/// - Visual separation between events on different days
/// - Smooth transitions between views
/// - Gesture-based navigation
///
/// ## Data Flow
/// - Uses `HomeViewModel` for event data
/// - Integrates with Core Data for persistence
/// - Shares state with `AppViewModel` for navigation
///
/// ## Example Usage
/// ```swift
/// HomeView(viewModel: HomeViewModel())
///     .environmentObject(AppViewModel.shared)
/// ```
struct HomeView: View {
    @Environment(\.colorScheme) var colorScheme // Detects system's light/dark mode
    let dateHelper = DateHelper()
    @State private var displayedMonth: String = ""
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: []) private var coreEvents: FetchedResults<CalendarEvent>
    @StateObject var viewModel: HomeViewModel
    @StateObject var appVM: AppViewModel = AppViewModel.appVM
    @StateObject var notificationVM = NotificationViewModel.instance
    
    @AppStorage("selectedPersona") private var selectedPersonaRaw: String = ChatPersona.tito.rawValue
    
    @State private var selectedEvent: Event?
    
    @State private var hasAskedForPermissions = false
    @State private var hasSetUpNotifications = false
    @State private var isShowingEvent = false
    @State private var isShowingMap = false
    @State private var isShowingChatbot = false
    @State private var selectedLocation: String = ""
    
    @State private var selectedEventTitle: String = ""
    
    var body: some View {
        ZStack(alignment: .top) {
            let events = viewModel.getUpcomingEvents()
            
            /// Main Content Area
            List {
                eventListContent(events: events)
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .listSectionSeparator(.hidden)
            .padding(.top, 60)
            
            if (events.isEmpty) {
                VStack {
                    Spacer()
                    Text("No Upcoming Events...")
                        .multilineTextAlignment(.center)
                        .font(Font.custom("Viga-Regular", size: 40))
                        .foregroundStyle(Color.gray.opacity(0.5))
                    Spacer()
                }
            }
            
            VStack {
                HStack {
                    Text(displayedMonth)
                        .font(Font.custom("Viga-Regular", size: 30))
                        .bold()
                        .foregroundStyle(colorScheme == .dark ? .white : .black)
                    
                    Spacer()
                    
                    headerButtonsView
                }
                .padding(.horizontal)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(colorScheme == .dark ? Constants.darkModeBackground : Constants.BackgroundColor)
        .sheet(isPresented: $isShowingEvent) {
            if let selectedEvent {
                EventInfoView(
                    event: selectedEvent,
                    showView: $appVM.showView
                )
                .scrollIndicators(.never)
                .presentationDetents([.height(650), .fraction(0.8)])
            }
            
        }
        .sheet(isPresented: $isShowingMap) {
            if let selectedEvent {
                LocationView(
                    location: selectedEvent.location ?? "",
                    event: selectedEvent.summary,
                    showView: $appVM.showView
                )
            }
            
        }
        .fullScreenCover(isPresented: $isShowingChatbot) {
            ChatBotView()
        }
        .onAppear {
            guard !hasSetUpNotifications else {return}
            hasSetUpNotifications = true
            displayedMonth = dateHelper.getCurrentMonth()
            
            Task {
                await performInitialSetup()
            }
        }
    }
    
    // MARK: Part of the view

    @ViewBuilder
    private var headerButtonsView: some View {
        if #available(iOS 26.0, *) {
            GlassEffectContainer {
                HStack(spacing: 0) {
                    if viewModel.isLastMonth() {
                        Button {
                            withAnimation(.snappy) { appVM.showView = .wrapped(.start) }
                        } label: {
                            Image("shpe_logo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 20, height: 20)
                                .frame(width: 44, height: 44)
                        }
                        Divider().frame(height: 20).opacity(0.3)
                    }
                    // ChatBot
                    Button {
                        isShowingChatbot = true
                    } label: {
                        Image("\(selectedPersonaRaw)")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 44, height: 44)
                            .foregroundStyle(colorScheme == .dark ? .white : .black)
                    }
                }
                .padding(4)
            }
            .glassEffect(.regular.interactive())
        } else {
            HStack(spacing: 0) {
                if viewModel.isLastMonth() {
                    Button {
                        withAnimation(.snappy) { appVM.showView = .wrapped(.start) }
                    } label: {
                        Image("shpe_logo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 20)
                            .frame(width: 44, height: 44)
                    }
                    Divider().frame(height: 20).opacity(0.3)
                }
                Button { } label: {
                    Image(systemName: "ellipsis.message")
                        .font(.system(size: 18))
                        .frame(width: 44, height: 44)
                        .foregroundStyle(colorScheme == .dark ? .white : .black)
                }
            }
            .padding(4)
        }
    }

    @ViewBuilder
    private func eventListContent(events: [Event]) -> some View {
        let groupedEvents = groupedEventsByDay(events)
        ForEach(groupedEvents, id: \.date) { group in
            Section {
                ForEach(Array(group.events.enumerated()), id: \.element.identifier) { index, event in
                    HStack(spacing: 7) {
                        if index == 0 {
                            dayView(date: group.date)
                        } else {
                            Spacer().frame(width: 35)
                        }
                        if #available(iOS 18.0, *) {
                            Button {
                                selectedEvent = event
                                isShowingEvent = true
                            } label: {
                                EventBox(event: event)
                                    .sensoryFeedback(.impact, trigger: isShowingEvent)
                            }
                        } else {
                            Button {
                                selectedEvent = event
                                isShowingEvent = true
                            } label: {
                                EventBox(event: event)
                                    .sensoryFeedback(.impact, trigger: isShowingEvent)
                            }
                        }
                    }
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                    .swipeActions(edge: .trailing) {
                        if notificationVM.isEventNotified(event) {
                            Button {
                                notificationVM.removeNotificationForSingleEvent(event: event, fetchedEvents: coreEvents, viewContext: viewContext)
                            } label: {
                                Label("Silence", systemImage: "bell.slash.fill").tint(.red)
                            }
                        } else {
                            Button {
                                notificationVM.notifyForSingleEvent(event: event, fetchedEvents: coreEvents, viewContext: viewContext)
                            } label: {
                                Label("Notify", systemImage: "bell").tint(.blue)
                            }
                        }
                        if #available(iOS 18.0, *) {
                            Button {
                                handleDirectionsTap(for: event)
                            } label: {
                                Label("Directions", systemImage: "point.topleft.filled.down.to.point.bottomright.curvepath")
                            }
                            .tint(.green)
                        } else {
                            Button {
                                handleDirectionsTap(for: event)
                            } label: {
                                Label("Directions", systemImage: "point.topleft.filled.down.to.point.bottomright.curvepath")
                            }
                            .tint(.green)
                        }
                    }
                    .swipeActions(edge: .leading) {
                        Button { print("Calendar") } label: {
                            Label("Add", systemImage: "calendar")
                        }
                    }
                }
            }
            .padding(.vertical, 15)
            .padding(.trailing, 15)
            .textCase(nil)
        }
    }
    
    private func performInitialSetup() async {
        let mappedEvents = await Task.detached { [coreEvents, viewContext] in
            return CoreFunctions().mapCoreEventToEvent(events: coreEvents, viewContext: viewContext)
        }.value
        
        await MainActor.run {
            NotificationViewModel.instance.pendingNotifications = mappedEvents
            notificationVM.allEvents = viewModel.events  // expose to Settings
        }
        
        if !hasAskedForPermissions {
            hasAskedForPermissions = true
            
            notificationVM.checkForPermission { allowed in
                if allowed {
                    // Move notification setup to background task
                    Task {
                        await setupAllNotifications()
                    }
                }
            }
        }
    }
    
    private func setupAllNotifications() async {
        let events = viewModel.events

        await MainActor.run {
            // Respect each flag loaded from CoreData — only schedule types the user has enabled
            if notificationVM.isGBMSelected          { setupNotificationsForEventType(events: events, eventType: "GBM") }
            if notificationVM.isInfoSelected         { setupNotificationsForEventType(events: events, eventType: "Info") }
            if notificationVM.isWorkShopSelected     { setupNotificationsForEventType(events: events, eventType: "Workshop") }
            if notificationVM.isVolunteeringSelected { setupNotificationsForEventType(events: events, eventType: "Volunteering") }
            if notificationVM.isSocialSelected       { setupNotificationsForEventType(events: events, eventType: "Social") }
        }
    }
    
    private func setupNotificationsForEventType(events: [Event], eventType: String) {
        notificationVM.turnOnEventNotification(
            events: events,
            eventType: eventType,
            fetchedEvents: coreEvents,
            viewContext: viewContext
        )
    }
    // Helper function to check if two events occur on the same day
    func sameDay(_ event1: Event, _ event2: Event) -> Bool {
        Calendar.current.isDate(
            event1.start.dateTime,
            inSameDayAs: event2.start.dateTime
        )
    }
    
    func handleDirectionsTap(for event: Event) {
        guard let location = event.location, !location.isEmpty else {
            print("Invalid location")
            return
        }
        
        Task {
            let isValid = await isValidLocation(location)
            
            if isValid {
                await MainActor.run {
                    selectedLocation = location
                    selectedEventTitle = event.summary
                    selectedEvent = event
                    isShowingMap = true
                }
            } else {
                print("Invalid location")
            }
        }
    }
    
    func groupedEventsByDay(_ events: [Event]) -> [(date: Date, events: [Event])] {
        let calendar = Calendar.current
        
        let grouped = Dictionary(grouping: events) { event in
            calendar.startOfDay(for: event.start.dateTime)
        }
        
        return grouped
            .sorted { $0.key < $1.key }
            .map { ($0.key, $0.value.sorted { $0.start.dateTime < $1.start.dateTime }) }
    }
    
    @ViewBuilder
    func dayView(date : Date) -> some View {
        if #available(iOS 26.0, *) {
            return VStack {
                Text(dateHelper.getDayAbbreviation(for: date))
                    .font(.callout)
                    .foregroundStyle(.red)
                
                Text(dateHelper.getDayNumber(for: date))
                    .font(.title2)
                    .fontWeight(.semibold)
            }
            .frame(width: 35)
            .padding(.vertical, 10)
            .padding(.horizontal)
            .glassEffect(.regular, in: .rect(cornerRadius: 20))
            .padding(.leading, 5)
        } else {
            return VStack {
                Text(dateHelper.getDayAbbreviation(for: date))
                    .font(.callout)
                    .foregroundStyle(.red)
                
                Text(dateHelper.getDayNumber(for: date))
                    .font(.title2)
                    .fontWeight(.semibold)
            }
            .frame(width: 35)
            .padding(.vertical, 10)
            .padding(.horizontal)
            .background(.ultraThinMaterial)
            .padding(.leading, 5)
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
    }
    
    func isValidLocation(_ location: String) async -> Bool {
        
        let geocoder = CLGeocoder()
        
        do {
            let placemarks = try await geocoder.geocodeAddressString(location)
            return !placemarks.isEmpty
        } catch {
            return false
        }
        
    }
}

//#Preview {
//    HomeView()
//        .preferredColorScheme(.dark)
//}
