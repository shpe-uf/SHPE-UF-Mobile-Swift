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
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: []) private var coreEvents: FetchedResults<CalendarEvent>

    var body: some View {
        TabView(selection: $selectedTab.onUpdate {
            if selectedTab == 0 {
                appVM.showView = "GuestCalendarView"
            }
            appVM.inMapView = false
        }) {
            AboutUsView()
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
        .gesture(
            // Swipe to switch between tabs
            DragGesture()
            .onChanged { value in
                if abs(value.translation.width) > abs(value.translation.height) {
                    // Horizontal swipe detected
                    dragOffset = value.translation
                }
            }
            .onEnded { value in
                if abs(value.translation.width) > abs(value.translation.height) {
                    // Handle horizontal swipe action
                    print("Horizontal swipe detected")
                    selectedTab = value.translation.width < 0 ? (selectedTab + 1)%3 : selectedTab - 1 == -1 ? 2 : abs(selectedTab - 1)%3
                }
                print(selectedTab)
                dragOffset = .zero
            },
            isEnabled: !appVM.inMapView
        )
    }
}

#Preview {
    GuestPageContentView()
}

