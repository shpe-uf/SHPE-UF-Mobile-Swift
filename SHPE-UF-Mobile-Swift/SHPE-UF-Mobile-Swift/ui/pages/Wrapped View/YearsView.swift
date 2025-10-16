//
//  YearsBannerView.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by Alex Milanes on 10/2/25.
//

import SwiftUI

/// **YearsBannerView:** Swift wrapped popup
struct YearsView: View {
    @Binding var showView: String
    @Environment(\.colorScheme) var colorScheme
    @StateObject var vm : YearsViewModel
    
    
    var body: some View {
        ZStack {
            (colorScheme == .dark ? Constants.darkModeBackground : Constants.BackgroundColor)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 10) {
                Spacer()
                VStack(spacing: 10) {
                    Text(vm.numYears == 1 ? "1 year!" : "\(vm.numYears) year!")
                        .font(.custom("Viga", size: 48))
                        .fontWeight(.regular)
                        .foregroundColor(Color(red: 253/255, green: 101/255, blue: 47/255))
                    
                    Text("Since you first became a SHPEito")
                        .font(.custom("Viga", size: 36))
                        .fontWeight(.regular)
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                        .lineLimit(2)
                }
                .multilineTextAlignment(.center) // keeps them centered
                
                Spacer()
                
                Text("Thank you for being a part of the familia :)")
                    .font(.custom("Viga", size: 24))
                    .fontWeight(.regular)
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
            }
            
            HStack {
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture {
                        showView = "YearsBannerView"
                    }
                
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture {
                        showView = "OverallBannerView"
                    }
            }
            .zIndex(0)
            .edgesIgnoringSafeArea(.all)
        }
        .overlay(
            StoryIndicatorView(showView: $showView, currentIndex: 9)
            .padding(.top, 8)
            .zIndex(1),
            alignment: .top
            )
    }
}
