//
//  HomeView.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by [Original Author] on [Original Date].
//  Updated by [Your Name] on [Today's Date] to optimize performance and fix layout issues.
//

import SwiftUI
import CoreData

/// **HomeView:** Displays upcoming events and navigation options.
struct HomeView: View {
    @Environment(\.colorScheme) var colorScheme // Detects system's light/dark mode
    let dateHelper = DateHelper()
    @State private var displayedMonth: String = ""

    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: []) private var coreEvents: FetchedResults<CalendarEvent>
    @StateObject var viewModel: HomeViewModel
    @StateObject var appVM: AppViewModel = AppViewModel.appVM

    @State private var offset: CGFloat = 0
    @State private var isDragging = false

    var body: some View {
        VStack(spacing: 0) {
            // 🟢 Fixed Navigation Bar Layout
            ZStack {
                Constants.orange
                    .frame(height: 100)
                    .edgesIgnoringSafeArea(.top) // Ensures it reaches screen edges

                HStack(spacing: 20) {
                    // Displaying the current month
                    Text(displayedMonth)
                        .font(Font.custom("Viga-Regular", size: 24))
                        .foregroundColor(.white)

                    Spacer()

                    // Button to navigate to SocialsView
                    Button { appVM.showView = "SocialsView" } label: {
                        Image("socialsicon")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 33, height: 32)
                            .padding(.top, UIScreen.main.bounds.width * 0.05)
                    }
                    .padding(.top, 10)

                    // Button to navigate to NotificationView
                    Button { appVM.showView = "NotificationView" } label: {
                        Image("Doorbell")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 33, height: 32)
                            .padding(.top, UIScreen.main.bounds.width * 0.05)
                    }
                    .padding(.top, 10)
                }
                .padding(.horizontal, UIScreen.main.bounds.width * 0.05)
            }

            // 🟢 Main Content (Upcoming Events or Empty State)
            mainContent
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(colorScheme == .dark ? Constants.darkModeBackground : Constants.BackgroundColor)
        }
        .background(colorScheme == .dark ? Constants.darkModeBackground : Constants.BackgroundColor)
        .edgesIgnoringSafeArea(.all)
        .overlay(overlayViews) // Handles showing additional views
    }

    /// **Main Content Area:** Displays either upcoming events or "No Upcoming Events" text.
    private var mainContent: some View {
        ZStack {
            if viewModel.getUpcomingEvents().isEmpty {
                Text("No Upcoming Events...")
                    .multilineTextAlignment(.center)
                    .font(Font.custom("Viga-Regular", size: 40))
                    .foregroundStyle(Color.gray.opacity(0.5))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                eventScrollView
            }
        }
    }

    /// **Event List:** Displays upcoming events using a scrollable list.
    private var eventScrollView: some View {
        ScrollView {
            ScrollViewReader { proxy in
                LazyVStack(spacing: 20) {
                    ForEach(viewModel.getUpcomingEvents().indices, id: \.self) { index in
                        eventRow(for: index)
                    }
                }
                .padding(.bottom, 100)
                .padding()
                .frame(maxWidth: .infinity)
                .padding(.trailing, 20)
            }
        }
        .onAppear {
            displayedMonth = dateHelper.getCurrentMonth()
            NotificationViewModel.instance.pendingNotifications = CoreFunctions().mapCoreEventToEvent(events: coreEvents, viewContext: viewContext)
        }
    }

    /// **Single Event Row:** Displays an event inside the scrollable list.
    private func eventRow(for index: Int) -> some View {
        let upcomingEvents = viewModel.getUpcomingEvents()
        let event = upcomingEvents[index]

        return HStack {
            // Display event date only if it's the first of the day
            if index == 0 || !sameDay(upcomingEvents[index - 1], upcomingEvents[index]) {
                VStack(alignment: .center, spacing: 0) {
                    Text(dateHelper.getDayAbbreviation(for: event.start.dateTime))
                        .font(Font.custom("UniversLTStd", size: 14))
                        .foregroundColor(colorScheme == .dark ? Constants.lightTextColor : Constants.DayTextColor)
                        .frame(width: 35, height: 15, alignment: .top)

                    Text(dateHelper.getDayNumber(for: event.start.dateTime))
                        .font(Font.custom("UniversLTStd", size: 20))
                        .foregroundColor(colorScheme == .dark ? Constants.lightTextColor : Constants.DayNumberTextColor)
                        .frame(width: 26, height: 16, alignment: .top)
                }
                .frame(width: 39, height: 45, alignment: .top)
                .padding(.horizontal, 2)
                .padding(.top, 4)
                .padding(.bottom, 8)
                .padding(.trailing, 10)
            }

            // Button to open the Event Details
            Button {
                withAnimation(.easeInOut(duration: 0.2)) {
                    appVM.showView = "EventView"
                    appVM.currentEventIndex = index
                }
            } label: {
                EventBox(event: event)
                    .frame(width: UIScreen.main.bounds.width * 0.75, height: 69)
            }
        }
    }

    /// **Overlay Views:** Handles additional views that appear over HomeView.
    private var overlayViews: some View {
        Group {
            if appVM.showView == "NotificationView" {
                NotificationView(viewModel: viewModel, showView: $appVM.showView)
            } else if appVM.showView == "EventView" {
                EventInfoView(event: viewModel.getUpcomingEvents()[appVM.currentEventIndex ?? 0], showView: $appVM.showView)
                    .transition(.move(edge: .trailing))
            } else if appVM.showView == "SocialsView" {
                SocialsView(showView: $appVM.showView)
                    .transition(.move(edge: .trailing))
            }
        }
        .offset(x: offset)
        .gesture(dragGesture)
    }

    /// **Drag Gesture:** Allows users to dismiss views by swiping.
    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { gesture in
                if appVM.showView == "LocationView" { return }
                isDragging = true
                offset = max(gesture.translation.width, 0)
            }
            .onEnded { _ in
                isDragging = false
                if offset > 100 {
                    withAnimation(.easeInOut(duration: appVM.showView == "EventView" ? 0.5 : 0.2)) {
                        appVM.showView = ""
                    }
                }
                withAnimation(.easeOut(duration: 0.2)) {
                    offset = 0
                }
            }
    }

    /// **Same Day Check:** Returns `true` if two events occur on the same day.
    private func sameDay(_ event1: Event, _ event2: Event) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(event1.start.dateTime, inSameDayAs: event2.start.dateTime)
    }
}
