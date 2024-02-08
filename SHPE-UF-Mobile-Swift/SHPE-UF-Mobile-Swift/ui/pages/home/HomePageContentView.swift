//
//  HomePageContentView.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by Matthew Segura on 2/8/24.
//

import SwiftUI

struct HomePageContentView: View{
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
