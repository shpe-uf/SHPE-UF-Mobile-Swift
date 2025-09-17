//
//  PointsView.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by Jesus Lopez on 10/23/23.
//

import SwiftUI

/// A dark-themed view displaying the user's points program information including:
/// - Current percentile ranking
/// - Seasonal points breakdown
/// - Event category tables
/// - Points redemption functionality
///
/// This view:
/// 1. Shows percentile ranking in a circular progress view
/// 2. Displays total and seasonal points
/// 3. Organizes events by category in tables
/// 4. Provides points redemption functionality
///
/// ## Visual Features
/// - Dark gradient background
/// - Animated circular progress indicator
/// - Themed seasonal point cards
/// - Interactive redemption button
///
/// ## Data Flow
/// - Uses PointsViewModel as data source
/// - Updates via ObservedObject
struct PointsViewDark: View {
    
    @ObservedObject var vm : PointsViewModel
    
    @State private var redeem = false;
    
    // GRADIENTS FOR POINTSUI
    
    var fallGradient : LinearGradient = LinearGradient(stops: [Gradient.Stop(color: Color(red: 0.04, green: 0.13, blue: 0.35), location: 0.00),
                                                               Gradient.Stop(color: Color(red: 0.18, green: 0.38, blue: 0.62), location: 1.00)],
                                                       startPoint: UnitPoint(x: 0.5, y: 0),
                                                       endPoint: UnitPoint(x: 0.5, y: 1))
    
    var springGradient : LinearGradient = LinearGradient(stops: [Gradient.Stop(color: Color(red: 0.6, green: 0.12, blue: 0.08), location: 0.00),
                                                                 Gradient.Stop(color: Color(red: 0.97, green: 0.46, blue: 0.3), location: 1.00)],
                                                         startPoint: UnitPoint(x: 0.5, y: 0),
                                                         endPoint: UnitPoint(x: 0.5, y: 1))
    
    var summerGradient : LinearGradient = LinearGradient(stops: [Gradient.Stop(color: Color(red: 0.04, green: 0.44, blue: 0.73), location: 0.00),
                                                                 Gradient.Stop(color: Color(red: 0.52, green: 0.8, blue: 1), location: 1.00)],
                                                         startPoint: UnitPoint(x: 0.5, y: 0),
                                                         endPoint: UnitPoint(x: 0.5, y: 1))
    
    let keys = ["General Body Meeting", "Workshop", "Cabinet Meeting", "Miscellaneous", "Corporate Event", "Social"]
    
    
    var body: some View {
        
        ScrollView {
            
            VStack() {
                
                
                ZStack(alignment: .bottom) {
                    
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: .infinity, height: 100)
                        .background(Color(red: 0.82, green: 0.35, blue: 0.09))
                        .ignoresSafeArea()
                    
                    
                    
                    Text("POINTS PROGRAM")
                        .font(.title).bold()
                        .foregroundStyle(.white)
                        .padding()
                    
                }
                
                // CIRCULAR PROGRESS
                ZStack {
                    
                    
                    CircularProgessViewDark(progress: Double(vm.springPercentile) / 100)
                    
                    
                    
                    VStack {
                        Text("SPRING:")
                            .font(.title)
                            .bold()
                            .foregroundStyle(.white)
                        Text("\(stringWithOrdinalSuffix(from : vm.springPercentile))")
                            .font(.title)
                            .bold()
                            .foregroundStyle(.white)
                        Text("Percentile")
                            .font(.title)
                            .bold()
                            .foregroundStyle(.white)
                    }
                    
                }
                .padding(.top, 50)
                
                
                
                // REDEEM BUTTON
                
                Button {
                    redeem.toggle()
                } label: {
                    RedeemPointsButton()
                        .foregroundColor(.black)
                }
                .padding(.vertical, 25)
                
                
                
                // DISPLAY POINTS
                VStack {
                    
                    Text("Total Points: \(vm.points)")
                        .font(.system(size: 20)).bold()
                        .foregroundColor(.white)
                    
                    PointsUI(points: vm.fallPoints, semester: "Fall", percent: vm.fallPercentile, gradient: fallGradient)
                    
                    PointsUI(points: vm.springPoints, semester: "Spring", percent: vm.springPercentile, gradient: springGradient)
                    
                    PointsUI(points: vm.summerPoints, semester: "Summer", percent: vm.summerPercentile, gradient: summerGradient)
                    
                }
                .padding(.vertical)
                
                
                VStack(spacing: 35) {
                    ForEach(keys, id: \.self) { key in
                        TableView(vm: vm, title: key)
                    }
                }
                .padding()
                
            }
        }
        .background(
            LinearGradient(
                stops: [Gradient.Stop(color: Color(red: 0, green: 0.12, blue: 0.21), location: 0.00)],
                startPoint: UnitPoint(x: 0.5, y: 0),
                endPoint: UnitPoint(x: 0.5, y: 1)
            )
        )
        
        .sheet(isPresented: $redeem, content: {
            RedeemView(vm: vm)
        })
        .backgroundStyle(.black)
        .ignoresSafeArea()
        
        
    }
    
    /// Converts an integer to a string with the appropriate ordinal suffix (st, nd, rd, th).
    ///
    /// This function:
    /// 1. Handles all positive and negative integers
    /// 2. Correctly applies English ordinal rules including special cases (11th, 12th, 13th)
    /// 3. Returns the number with the proper suffix
    ///
    /// - Parameter number: The integer to convert
    /// - Returns: String representation with ordinal suffix (e.g. "1st", "2nd", "3rd", "4th")
    ///
    /// ## Rules Implemented
    /// - Numbers ending in 1 (except 11) → "st" (1st, 21st, 31st)
    /// - Numbers ending in 2 (except 12) → "nd" (2nd, 22nd, 32nd)
    /// - Numbers ending in 3 (except 13) → "rd" (3rd, 23rd, 33rd)
    /// - All other numbers → "th" (including 11th, 12th, 13th)
    ///
    /// ## Examples
    /// ```
    /// stringWithOrdinalSuffix(from: 1)    // Returns "1st"
    /// stringWithOrdinalSuffix(from: 22)   // Returns "22nd"
    /// stringWithOrdinalSuffix(from: 113)  // Returns "113th"
    /// stringWithOrdinalSuffix(from: -5)   // Returns "-5th"
    /// ```
    func stringWithOrdinalSuffix(from number: Int) -> String {
        let tensPlace = abs(number) % 100
        let onesPlace = abs(number) % 10
        
        switch (tensPlace, onesPlace) {
        case (11...13, _):
            return "\(number)th"
        case (_, 1):
            return "\(number)st"
        case (_, 2):
            return "\(number)nd"
        case (_, 3):
            return "\(number)rd"
        default:
            return "\(number)th"
        }
    }
}

#Preview {
    PointsViewDark(vm: PointsViewModel(shpeito:
                                        SHPEito()
                                      ))
    .preferredColorScheme(.light)
}
