//
//  WrappedContainerView.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by David Denis on 12/17/25.
//

import SwiftUI

// MARK: Keep them in this order to be displayed properly
enum WrappedRoute: Int, CaseIterable {
    case start
    
    case intro
    
    case pointsPattern
    case totalPoints
    
    case categoryBanner
    case category
    
    case yearsBanner
    case years
    
    case overallBanner
    case overall

    
    case finale
}


struct WrappedContainerView: View {
    @Binding var route: AppRoute

    @StateObject var vm: WrappedViewModel

    var body: some View {
        TabView(selection: $vm.page) {

            WrappedIntroView(vm: vm)
                .tag(WrappedRoute.intro)
            
            PointsPatternView(totalPoints: vm.shpeito.points)
                .tag(WrappedRoute.pointsPattern)
            
            TotalPointsView(totalPoints: vm.shpeito.points, percentile: vm.shpeito.fallPercentile)
                .tag(WrappedRoute.totalPoints)
            
            CategoryBannerView(vm: vm)
                .tag(WrappedRoute.categoryBanner)

            CategoryView(vm: vm)
                .tag(WrappedRoute.category)
            
            YearsBannerView(vm: vm)
                .tag(WrappedRoute.yearsBanner)

            YearsView(vm: vm)
                .tag(WrappedRoute.years)


            OverallBannerView(vm: vm)
                .tag(WrappedRoute.overallBanner)

            OverallView(vm: vm)
                .tag(WrappedRoute.overall)
            
            WrappedFinalView(route: $route)
                .tag(WrappedRoute.finale)
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .ignoresSafeArea()
        .safeAreaInset(edge: .top) {
            StoryIndicatorView(vm: vm)
            .padding(.horizontal)
            .padding(.top, 6)
        }
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in vm.isPaused = true }
                .onEnded { _ in vm.isPaused = false }
        )
    }
}

#Preview {
    WrappedContainerView(route: .constant(.wrapped(.intro)), vm: WrappedViewModel(SHPEito: SHPEito.mockSHPEito, categorizedEvents: [:]))
        .preferredColorScheme(.dark)
}
