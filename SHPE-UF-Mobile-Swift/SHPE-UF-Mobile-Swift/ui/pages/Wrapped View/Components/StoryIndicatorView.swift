//
//  YearsViewModel.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by Alex Milanes on 10/2/25.
//

import SwiftUI

struct StoryIndicatorView: View {
    
    @ObservedObject var vm: WrappedViewModel
    
    // Minus 1 so we do not account for the overlay to start Wrapped
    let total: Int = WrappedRoute.allCases.count - 1
    
    
    
    var body: some View {
        HStack(spacing: 6) {
            ForEach(0..<total, id: \.self) { index in
                
                let pageRaw = index + 1
                
                let isPastOrCurrent = pageRaw <= vm.page.rawValue
                
                ProgressView(value: vm.progressValue(for: index), total: 1)
                    .progressViewStyle(.linear)
                    .tint(.white)
                    .frame(height: 4)
                    .clipShape(RoundedRectangle(cornerRadius: 2))
                    .opacity(isPastOrCurrent ? 1 : 0.4)
            }
        }
        .padding(.horizontal)
        .onAppear {
            if vm.hasStarted {
                vm.startIfNeeded()
            }
        }
        .onChange(of: vm.hasStarted) { started in
            if started {
                vm.startIfNeeded()
            }
        }
        .onChange(of: vm.isPaused) { paused in
            paused ? vm.pause() : vm.resume()
        }
        .onChange(of: vm.page) { _ in
            vm.resetProgressForNewPage()
        }
        .onDisappear {
            vm.pause()
        }
    }
}


