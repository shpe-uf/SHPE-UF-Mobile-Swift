//HOMEPAGE

import SwiftUI

/// Creates a new Binding that executes a closure when the value changes.
    ///
    /// This extension provides a convenient way to add side effects to binding changes
    /// while maintaining the original binding functionality.
    ///
    /// - Parameter closure: The action to perform when the binding's value changes
    /// - Returns: A new binding that triggers the closure on changes
    ///
    /// ## Usage Example
    /// ```swift
    /// @State private var selectedTab = 0
    ///
    /// TabView(selection: $selectedTab.onUpdate {
    ///     print("Tab changed to \(selectedTab)")
    /// }) {
    ///     // Tab content...
    /// }
    /// ```
    ///
    /// ## Important Notes
    /// - The closure is called after the new value is set
    /// - Works with any Binding type (Int, String, Bool, etc.)
    /// - Maintains all original binding functionality
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

/// The main tabbed interface for the application, containing three primary views:
/// 1. Home (Calendar View)
/// 2. Points (Leaderboard)
/// 3. Profile
///
/// This view:
/// - Manages tab navigation with swipe gestures
/// - Handles shared state through AppViewModel
/// - Adapts to light/dark mode
/// - Integrates with Core Data
///
/// ## Key Features
/// - TabView with custom icons
/// - Swipe gesture navigation between tabs
/// - State management for current view
/// - Location services integration
///
/// ## Example Usage
/// ```swift
/// HomePageContentView()
///     .environment(\.managedObjectContext, persistenceController.container.viewContext)
/// ```
struct HomePageContentView: View {
    @StateObject private var locationManager:LocationManager = LocationManager()
    @StateObject private var appVM:AppViewModel = AppViewModel.appVM
    @Environment(\.colorScheme) var colorScheme
    @State private var selectedTab: Int = 0
    @State private var dragOffset = CGSize.zero
    @AppStorage("selectedPersona") private var selectedPersonaRaw: String = ChatPersona.tito.rawValue

    private var chatbotPersona: ChatPersona {
        ChatPersona(rawValue: selectedPersonaRaw) ?? .tito
    }
    
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

            ChatBotView()
                .tag(3)
                .tabItem {
                    if let uiImage = UIImage(named: chatbotPersona.imageName)?
                        .preparingThumbnail(of: CGSize(width: 25, height: 25)) {
                        Image(uiImage: uiImage)
                    }
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
                        selectedTab = value.translation.width < 0 ? (selectedTab + 1)%4 : selectedTab - 1 == -1 ? 3 : abs(selectedTab - 1)%4
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


