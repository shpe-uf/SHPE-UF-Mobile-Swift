//
//  PointsView.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by Jesus Lopez on 10/23/23.
//

import SwiftUI
import Foundation


/// The main view displaying the SHPEito points program information.
///
/// This view:
/// 1. Shows the user's current percentile ranking
/// 2. Displays total and seasonal points
/// 3. Provides a redemption interface
/// 4. Shows categorized event history
///
/// ## Key Components
/// - Circular progress view showing current percentile
/// - Seasonal points cards with custom gradients
/// - Event history tables by category
/// - Redemption sheet modal
///
/// ## Data Flow
/// - Uses `PointsViewModel` as state object
/// - Integrates with Core Data via `DataManager`
/// - Automatically loads data on appear
///
/// ## Example Usage
/// ```swift
/// PointsView(vm: PointsViewModel(shpeito: sampleUser))
///     .environmentObject(DataManager.shared)
/// ```
struct PointsView: View {
    
    @StateObject var vm : PointsViewModel
    @EnvironmentObject var manager: DataManager
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: []) private var user: FetchedResults<User>
    @FetchRequest(sortDescriptors: []) private var coreEvents: FetchedResults<CoreUserEvent>
    
    @State private var redeem = false;
    @State private var isShowingSummerEvents : Bool = false;
    @State private var isShowingFallEvents : Bool = false;
    @State private var isShowingSpringEvents : Bool = false;
    @State private var eventsIndex : Int = 0;
    @State private var selection: PresentationDetent = .height(450)
    @State private var semester: String = "Fall"
    
    @Namespace private var nameSpace
    
    private let currentMonth:Int = Calendar.current.component(.month, from: Date())
    
    // EVENT TYPES
    var body: some View {
        VStack(spacing: 0) {
            
            Text("Points")
                .font(Font.custom("Viga-Regular", size: 30))
                .bold()
                .foregroundStyle(colorScheme == .dark ? .white : .black)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            
            // CIRCULAR PROGRESS
            ZStack {
                CircularProgessView(vm: vm, progress: Double(90) / 100)
                
                VStack {
                    if vm.gettingPoints {
                        Text("Loading")
                            .font(.title)
                            .bold()
                        Text("Points...")
                            .font(.title)
                            .bold()
                    }
                    else {
                        Text(currentMonth > 0 && currentMonth < 6 ? "SPRING:" : currentMonth > 5 && currentMonth < 9 ? "SUMMER:" : "FALL:")
                            .font(.title)
                            .bold()
                        Text("\(stringWithOrdinalSuffix(from : currentMonth > 0 && currentMonth < 6 ? vm.springPercentile : currentMonth > 5 && currentMonth < 9 ? vm.summerPercentile : vm.fallPercentile))")
                            .font(.title)
                            .bold()
                        Text("Percentile")
                            .font(.title)
                            .bold()
                    }
                }
            }
            .padding(.top, 50)
            
            // REDEEM BUTTON
            if #available(iOS 26.0, *) {
                Button {
                    redeem.toggle()
                } label: {
                    ZStack {
                        Text("Redeem Code")
                            .font(Font.custom("Viga-Regular", size: 20)).bold()
                            .foregroundStyle(.white)
                    }
                    .frame(width: 250, height: 50)
                    
                }
                .glassEffect(.clear.tint(Color.black).interactive(), in: .rect(cornerRadius: 16.0))
                .padding(.top, 35)
                .padding(.horizontal)
                .matchedTransitionSource(id: "redeem_code", in: nameSpace)
                
            } else {
                RedeemPointsButton()
                //.foregroundColor(.black)
            }
            
            // DISPLAY POINTS
            VStack {
                
                Text("Total Points: \(vm.points)")
                    .font(Font.custom("Viga-Regular", size: 20)).bold()
                
                if #available(iOS 26.0, *) {
                    PointsUI(points: vm.fallPoints, semester: "Fall", percent: vm.fallPercentile, gradient: Constants.fallGradient, isShowingList: $isShowingFallEvents)
                        .matchedTransitionSource(id: "fallPoints", in: nameSpace)
                    
                    PointsUI(points: vm.springPoints, semester: "Spring", percent: vm.springPercentile, gradient: Constants.springGradient, isShowingList: $isShowingSpringEvents)
                        .matchedTransitionSource(id: "springPoints", in: nameSpace)
                    
                    PointsUI(points: vm.summerPoints, semester: "Summer", percent: vm.summerPercentile, gradient: Constants.summerGradient, isShowingList: $isShowingSummerEvents)
                        .matchedTransitionSource(id: "summerPoints", in: nameSpace)
                } else {
                    /// Fallback on earlier versions
                    
                    PointsUI(points: vm.fallPoints, semester: "Fall", percent: vm.fallPercentile, gradient: Constants.fallGradient, isShowingList: $isShowingFallEvents)
                    
                    PointsUI(points: vm.springPoints, semester: "Spring", percent: vm.springPercentile, gradient: Constants.springGradient, isShowingList: $isShowingSpringEvents)
                    
                    PointsUI(points: vm.summerPoints, semester: "Summer", percent: vm.summerPercentile, gradient: Constants.summerGradient, isShowingList: $isShowingSummerEvents)
                }
            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            (colorScheme == .dark ? Constants.darkGradient : Constants.lightGradient)
                .ignoresSafeArea()
        )
        .onAppear(perform: {
            vm.gettingPoints = vm.points == 0
            vm.gettingEvents = true
            vm.setShpeitoPoints()
            vm.setShpeitoPercentiles()
            vm.getShpeitoPoints()
            vm.getUserEvents(coreEvents: coreEvents, viewContext: viewContext)
            CoreFunctions().editUserInCore(users: user, viewContext: viewContext, shpeito: vm.shpeito)
        })
        .sheet(isPresented: $redeem, content: {
            if #available(iOS 18.0, *) {
                RedeemView(vm: vm)
                    .presentationDetents ([.height(450), .fraction(0.6)], selection: $selection)
                    .navigationTransition(.zoom(sourceID: "redeem_code", in: nameSpace))
            } else {
                // Fallback on earlier versions
                RedeemView(vm: vm)
                    .presentationDetents ([.height(450), .fraction(0.6)], selection: $selection)
            }
            
        })
        .sheet(isPresented: $isShowingFallEvents) {
            if #available(iOS 26.0, *) {
                sheetView(semester: .fall)
                    .scrollIndicators(.never)
                    .presentationDetents ([.height(450), .fraction(0.6)])
                    .navigationTransition(.zoom(sourceID: "fallPoints", in: nameSpace))
            } else {
                // Fallback on earlier versions
                sheetView(semester: .fall)
                    .scrollIndicators(.never)
                    .presentationDetents ([.height(450), .fraction(0.6)])
            }
        }
        .sheet(isPresented: $isShowingSpringEvents) {
            if #available(iOS 26.0, *) {
                sheetView(semester: .spring)
                    .scrollIndicators(.never)
                    .presentationDetents ([.height(450), .fraction(0.6)])
                    .navigationTransition(.zoom(sourceID: "springPoints", in: nameSpace))
            } else {
                // Fallback on earlier versions
                sheetView(semester: .spring)
                    .scrollIndicators(.never)
                    .presentationDetents ([.height(450), .fraction(0.6)])
            }
        }
        .sheet(isPresented: $isShowingSummerEvents) {
            if #available(iOS 26.0, *) {
                sheetView(semester: .summer)
                    .scrollIndicators(.never)
                    .presentationDetents ([.height(450), .fraction(0.6)])
                    .navigationTransition(.zoom(sourceID: "summerPoints", in: nameSpace))
                
            } else {
                // Fallback on earlier versions
                sheetView(semester: .summer)
                    .scrollIndicators(.never)
                    .presentationDetents ([.height(450), .fraction(0.6)])
            }
        }
        
    }
    
    /// Converts an integer to a string with the appropriate ordinal suffix (st, nd, rd, th).
    ///
    /// This function:
    /// 1. Handles all positive and negative integers
    /// 2. Correctly applies English ordinal rules including special cases (11th, 12th, 13th)
    /// 3. Returns the number with the appropriate suffix
    ///
    /// - Parameter number: The integer to convert
    /// - Returns: String representation with ordinal suffix (e.g., "1st", "2nd", "3rd", "4th")
    ///
    /// ## Rules Implemented
    /// - Numbers ending in 1 (except 11) → "st" (1st, 21st, 31st)
    /// - Numbers ending in 2 (except 12) → "nd" (2nd, 22nd, 32nd)
    /// - Numbers ending in 3 (except 13) → "rd" (3rd, 23rd, 33rd)
    /// - All others → "th" (including 11th, 12th, 13th)
    ///
    /// ## Example Usage
    /// ```swift
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
    
    func sheetView(semester: Semester) -> some View {
        
        // only keys that have at least 1 event
        let filteredKeys = Constants.keys.filter { key in
            if let events = vm.categorizedEvents[key] {
                return events.contains { $0.semester == semester }
            }
            return false
        }
        
        return ScrollView {
            VStack(spacing: 25) {
                ForEach(filteredKeys.indices, id: \.self) { index in
                    let key = filteredKeys[index]
                    
                    // get events
                    let filteredEvents = vm.categorizedEvents[key]!.filter { $0.semester == semester }
                    
                    TableView(events: filteredEvents, title: key)
                    
                    // don't show the divider after last event
                    if index != filteredKeys.count - 1 {
                        Divider()
                            .padding(.horizontal)
                    }
                }
            }
        }
    }
}

#Preview {
    PointsView(vm: PointsViewModel(shpeito: SHPEito()))
        .preferredColorScheme(.dark)
}
