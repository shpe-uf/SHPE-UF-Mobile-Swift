// HOMEPAGE

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
    @StateObject private var locationManager: LocationManager = LocationManager()
    @StateObject private var appVM: AppViewModel = AppViewModel.appVM
    @Environment(\.colorScheme) var colorScheme
    @State private var selectedTab: Int = 0
    @State private var dragOffset = CGSize.zero
    @State private var showChatBot = false
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: []) private var coreEvents: FetchedResults<CalendarEvent>
    
    // total number of tabs
    private let tabCount = 4
    
    var body: some View {
        ZStack {
            TabView(selection: $selectedTab.onUpdate {
                if selectedTab == 0 {
                    appVM.showView = "HomeView"
                    appVM.currentEventIndex = nil
                }
                appVM.inMapView = false
            }) {
                
                // Tab 0 - Home
                HomeView(viewModel: HomeViewModel(coreEvents: coreEvents, viewContext: viewContext))
                    .environmentObject(locationManager)
                    .tag(0)
                    .tabItem {
                        Image(selectedTab == 0 ? "icon_calendar" :
                                colorScheme == .dark ? "unclicked_calendar" : "unclicked_calendar_light")
                    }
                
                // Tab 1 - Points
                PointsView(vm: PointsViewModel(shpeito: appVM.shpeito))
                    .tag(1)
                    .tabItem {
                        Image(selectedTab == 1 ? "clicked_leaderboard" :
                                colorScheme == .dark ? "dark_leaderboard" : "Leaderboard")
                    }
                
                // Tab 2 - Profile
                ProfileView(vm: ProfileViewModel(shpeito: appVM.shpeito))
                    .tag(2)
                    .tabItem {
                        Image(selectedTab == 2 ? "clicked_customer" :
                                colorScheme == .dark ? "dark_customer" : "Customer")
                    }
            }
            .gesture(
                // Swipe to switch between tabs
                DragGesture()
                    .onChanged { value in
                        if abs(value.translation.width) > abs(value.translation.height) {
                            dragOffset = value.translation
                        }
                    }
                    .onEnded { value in
                        if abs(value.translation.width) > abs(value.translation.height) {
                            if value.translation.width < 0 {
                                selectedTab = (selectedTab + 1) % tabCount
                            } else {
                                selectedTab = (selectedTab - 1 + tabCount) % tabCount
                            }
                        }
                        dragOffset = .zero
                    },
                isEnabled: !appVM.inMapView
            )

            // Floating chatbot button
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: { showChatBot = true }) {
                        Image("tito")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 56, height: 56)
                            .clipShape(Circle())
                            .background(
                                Circle()
                                    .fill(.orangeButton)
                            )
                            .overlay(
                                Circle()
                                    .stroke(colorScheme == .dark ? .white : .black, lineWidth: 2)
                            )
                            .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                    .padding(.trailing, 15)
                    .padding(.bottom, 60) // Above tab bar
                }
            }
        }
            .fullScreenCover(isPresented: $showChatBot) {
                ChatBotView()
            }
        }
    }
    
    #Preview {
        HomePageContentView()
    }

