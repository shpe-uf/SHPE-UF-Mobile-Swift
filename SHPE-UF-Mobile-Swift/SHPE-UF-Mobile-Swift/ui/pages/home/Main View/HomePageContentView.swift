//HOMEPAGE

import SwiftUI

extension Binding {
    func onUpdate(_ closure: @escaping () -> Void) -> Binding<Value> {
        Binding(get: {
            wrappedValue
        }, set: { newValue in
            wrappedValue = newValue
            closure()
        })
    }
}

struct HomePageContentView: View {
    @StateObject private var locationManager:LocationManager = LocationManager()
    @StateObject private var appVM:AppViewModel = AppViewModel.appVM
    @Environment(\.colorScheme) var colorScheme
    @State private var selectedTab: Int = 0
    @State private var dragOffset = CGSize.zero
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: []) private var coreEvents: FetchedResults<CalendarEvent>
    
    @StateObject var pointsVM: PointsViewModel = PointsViewModel(shpeito: AppViewModel.appVM.shpeito)
    
    @FetchRequest(sortDescriptors: []) private var coreUserEvents: FetchedResults<CoreUserEvent>
    
    var body: some View {
        TabView(selection: $selectedTab.onUpdate {
            if selectedTab == 0
            {
                appVM.showView = .home
                appVM.currentEventIndex = nil
            }
            appVM.inMapView = false
        }){
            HomeView(viewModel: HomeViewModel(coreEvents: coreEvents, viewContext: viewContext))
                .environmentObject(locationManager)
                .tag(0)
                .tabItem {
                    Image(selectedTab == 0 ? "icon_calendar" : colorScheme == .dark ? "unclicked_calendar":"unclicked_calendar_light")
                }
            
            PointsView(vm: pointsVM)
                .tag(1)
                .tabItem {
                    Image(selectedTab == 1 ? "clicked_leaderboard" : colorScheme == .dark ? "dark_leaderboard":"Leaderboard")
                }
            
            ProfileView(vm: ProfileViewModel(shpeito: appVM.shpeito))
                .tag(2)
                .tabItem {
                    Image(selectedTab == 2 ? "clicked_customer" : colorScheme == .dark ? "dark_customer":"Customer")
                }
            
        }
        .onAppear {
            if pointsVM.categorizedEvents.isEmpty {
                pointsVM.getUserEvents(
                    coreEvents: coreUserEvents,
                    viewContext: viewContext
                )
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
        .overlay {
            if appVM.showView == .wrapped(.start) {
                ZStack {
                    Color.black.opacity(0.752)
                        .ignoresSafeArea()
                        .zIndex(0)
                    
                    WrappedView(showView: $appVM.showView)
                        .transition(.move(edge: .trailing))
                        .zIndex(1)
                }
            }
            if appVM.showView == .wrapped(.intro) {
                ZStack {
                    Color.black.opacity(0.75).ignoresSafeArea()
                    
                    WrappedContainerView(route: $appVM.showView, vm: WrappedViewModel(SHPEito: appVM.shpeito, categorizedEvents: pointsVM.categorizedEvents))
                        .transition(.move(edge: .bottom))
                }
            }
        }
    }
}

#Preview {
    HomePageContentView()
}


