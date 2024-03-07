//HOMEPAGE

import SwiftUI

struct HomePageContentView: View {
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    VStack {
                        Image(systemName: "calendar") // Use system names as placeholders
                        Text("Home")
                    }
                }
            
            Text("Points Page")
                .tabItem {
                    VStack {
                        Image(systemName: "rosette")
                        Text("Points")
                    }
                }
            
            Text("Profile")
                .tabItem {
                    VStack {
                        Image(systemName: "person.fill")
                        Text("Profile")
                    }
                }
        }
        .accentColor(colorScheme == .dark ? .white : .black) // Adjust the accent color for icon based on the scheme
        .onAppear {
            let tabBarAppearance = UITabBarAppearance()
            if colorScheme == .dark {
                tabBarAppearance.backgroundColor = UIColor(named: "DarkBlue") // Define "DarkBlue" in your asset catalog
                UITabBar.appearance().standardAppearance = tabBarAppearance
                UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
            } else {
                tabBarAppearance.backgroundColor = UIColor.white
                UITabBar.appearance().standardAppearance = tabBarAppearance
                UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
            }
        }
    }
}

struct HomePageContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HomePageContentView()
                .preferredColorScheme(.light)
            HomePageContentView()
                .preferredColorScheme(.dark)
        }
    }
}

