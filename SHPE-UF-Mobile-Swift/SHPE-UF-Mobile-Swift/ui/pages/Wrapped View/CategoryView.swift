//
//  CategoryView.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by Alex Milanes on 11/5/25.
//

import SwiftUI

struct CategoryView: View {
    @Binding var showView: String
    @Environment(\.colorScheme) var colorScheme
    @StateObject var vm : YearsViewModel
    
    private var orange: Color {
        colorScheme == .dark
        ? Color(red: 253/255, green: 101/255, blue: 47/255)
        : Color(red: 211/255, green: 58/255, blue: 2/255)
    }
    
    
    var body: some View {
        ZStack {
            (colorScheme == .dark ? Constants.darkModeBackground : Constants.BackgroundColor)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 10) {
                Spacer()
                VStack(spacing: 10) {
                    Text("Top Category")
                        .font(.custom("Viga", size: 36))
                        .fontWeight(.regular)
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                        .lineLimit(2)
                    
                    Text("General Body Meeting")
                        .font(.custom("Viga", size: 48))
                        .fontWeight(.regular)
                        .foregroundColor(orange)
                }
                .multilineTextAlignment(.center)
                
                Spacer()
                
                Text("You attended X\nGeneral Body Meeting events")
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
                        showView = "CategoryBannerView"
                    }
                
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture {
                        showView = "YearsBannerView"
                    }
            }
            .zIndex(0)
            .edgesIgnoringSafeArea(.all)
        }
        .overlay(
            StoryIndicatorView(showView: $showView, currentIndex: 7)
            .padding(.top, 8)
            .zIndex(1),
            alignment: .top
            )
    }
}
