import SwiftUI
import CoreData
import MapKit

struct GuestCalendarView: View {
    // ViewModel
    @StateObject var viewModel: HomeViewModel
    @StateObject var appVM: AppViewModel = AppViewModel.appVM
    let dateHelper = DateHelper()

    @Environment(\.colorScheme) var colorScheme
    @State private var displayedMonth: String = ""

    @State private var selectedEvent: Event?
    @State private var isShowingEvent = false
    @State private var isShowingMap = false
    @State private var selectedLocation: String = ""
    @State private var selectedEventTitle: String = ""

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
                let events = viewModel.getUpcomingEvents()

                if events.isEmpty {
                    Text("No Upcoming Events...")
                        .multilineTextAlignment(.center)
                        .font(Font.custom("Viga-Regular", size: 40))
                        .foregroundColor(Color.gray.opacity(0.5))
                    Spacer()
                }

                List {
                    eventListContent(events: events)
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .listSectionSeparator(.hidden)
                .background((colorScheme == .dark ? Constants.darkGradient : Constants.lightGradient))
                .onAppear {
                    displayedMonth = dateHelper.getCurrentMonth()
                }
            }

        }
        .background((colorScheme == .dark ? Constants.darkGradient : Constants.lightGradient))
        .edgesIgnoringSafeArea(.all)
        .sheet(isPresented: $isShowingEvent) {
            if let selectedEvent {
                EventInfoView(event: selectedEvent, showView: $appVM.showView)
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
    }

    // MARK: Part of the view

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
                        Button {
                            selectedEvent = event
                            isShowingEvent = true
                        } label: {
                            EventBox(event: event)
                                .sensoryFeedback(.impact, trigger: isShowingEvent)
                        }
                    }
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                    .swipeActions(edge: .trailing) {
                        Button {
                            handleDirectionsTap(for: event)
                        } label: {
                            Label("Directions", systemImage: "point.topleft.filled.down.to.point.bottomright.curvepath")
                        }
                        .tint(.green)
                    }
                }
            }
            .padding(.vertical, 15)
            .padding(.trailing, 15)
            .textCase(nil)
        }
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
                    AppViewModel.appVM.inMapView = true
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
    func dayView(date: Date) -> some View {
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
            let placemarks = try await geocoder.geocodeAddressString(location, in: Constants.gainesvilleGeocodingRegion)
            return !placemarks.isEmpty
        } catch {
            return false
        }
    }
}
