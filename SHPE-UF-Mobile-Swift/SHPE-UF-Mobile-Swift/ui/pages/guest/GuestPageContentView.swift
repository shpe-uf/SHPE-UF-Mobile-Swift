//
//  GuestPageContentView.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by Carlos Chavez on 3/3/25.
//

import SwiftUI
import CoreData


struct GuestPageContentView: View {
    @State private var selectedTab: Int = 0
    @StateObject private var appVM: AppViewModel = AppViewModel.appVM
    @Environment(\.colorScheme) var colorScheme
    @State private var dragOffset = CGSize.zero
    @State private var carouselIsDragging = false
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: []) private var coreEvents: FetchedResults<CalendarEvent>

    private var swipeTabs: some Gesture {
        DragGesture()
        .onEnded { value in
            // if the carousel is in mid-drag, bail out early
            guard !carouselIsDragging else {
                carouselIsDragging = false
                return
            }

            let h = value.translation.width
            let v = value.translation.height
            let threshold: CGFloat = 50
            guard abs(h) > abs(v), abs(h) > threshold else { return }

            withAnimation {
                if h < 0 {
                    selectedTab = min(selectedTab + 1, 2)
                } else {
                    selectedTab = max(selectedTab - 1, 0)
                }
            }
        }
    }
    
    var body: some View {
        TabView(selection: $selectedTab.onUpdate {
            if selectedTab == 0 {
                appVM.showView = "GuestCalendarView"
            }
            appVM.inMapView = false
        }) {
            AboutUsView(carouselIsDragging: $carouselIsDragging)
                .tag(0)
                .tabItem {
                    Image(selectedTab == 0 ? "AboutUs" : colorScheme == .dark ? "unclicked_AboutUs":"unclicked_AboutUs_light")
                
                }
            
            GuestCalendarView(viewModel: HomeViewModel(coreEvents: coreEvents, viewContext: viewContext))
                .tag(1)
                .tabItem {
                    Image(selectedTab == 1 ? "icon_calendar" : colorScheme == .dark ? "unclicked_calendar":"unclicked_calendar_light")
                }
            
            
            GuestPartnersView()
                .tag(2)
                .tabItem {
                    Image(selectedTab == 2 ? "clicked_handshake" : colorScheme == .dark ? "unclicked_handshake":"unclicked_handshake_light")
            
                }
        }
        .simultaneousGesture(swipeTabs)
    }
}

#Preview {
    GuestPageContentView()
}

