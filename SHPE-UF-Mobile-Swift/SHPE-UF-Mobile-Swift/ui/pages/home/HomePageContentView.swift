//
//  HomePageContentView.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by Matthew Segura on 2/8/24.
//

import SwiftUI

struct HomePageContentView: View{
    init() {
           // Customize the appearance of the tab bar
        UITabBar.appearance().barTintColor = UIColor(Constants.BackgroundColor)
           UITabBar.appearance().backgroundColor = UIColor(Constants.BackgroundColor)
       }
    var body: some View{
        
        TabView{
            HomeView()
                .tabItem{
                    Image("icon_calendar")
                   
                }
            Text("Points Page")
                .tabItem{
                    Image("Leaderboard")
            
                }
            Text("Profile")
                .tabItem{
                    Image("Customer")
                }
            
        }
        
    }
}
#Preview {
    HomePageContentView()
}
