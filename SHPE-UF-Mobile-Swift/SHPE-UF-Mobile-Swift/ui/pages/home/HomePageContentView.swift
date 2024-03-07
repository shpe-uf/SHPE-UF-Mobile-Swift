//HOMEPAGE

import SwiftUI

struct HomePageContentView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var isCalendarSelected = true
    @State private var isPointsSelected = false
    @State private var isProfileSelected = false
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Button(action: {
                        isCalendarSelected.toggle()
                    }){
                        Image(colorScheme == .dark ? "icon_calendar":"icon_calendar")
                    }
                    
                }
            
            Text("Points Page")
                .tabItem {
                    Button(action: {
                        isPointsSelected.toggle()
                    }){
                        Image(colorScheme == .dark ? "dark_leaderboard":"Leaderboard")
                    }
                        
                    
                }
            
            Text("Profile")
                .tabItem {
                    Button(action: {
                        isProfileSelected.toggle()
                    }){
                        Image(colorScheme == .dark ? "dark_customer":"Customer")
                    }
                    
                    
                }
        }

    }
}

#Preview {
    HomePageContentView()
}


