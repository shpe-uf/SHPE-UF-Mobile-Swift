//
//  PointsView.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by Jesus Lopez on 10/23/23.
//

import SwiftUI
import Foundation


struct PointsView: View {
    
    @StateObject var vm : PointsViewModel
    @EnvironmentObject var manager: DataManager
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: []) private var user: FetchedResults<User>
    @FetchRequest(sortDescriptors: []) private var coreEvents: FetchedResults<CoreUserEvent>
    
    @State private var redeem = false;
    private let currentMonth:Int = Calendar.current.component(.month, from: Date())
    
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
    
    // EVENT TYPES
    
    let keys = ["General Body Meeting", "Workshop", "Cabinet Meeting", "Corporate Event", "Social", "Miscellaneous"]
    
    var body: some View {
        
        
            
            VStack() {
                
                
                ZStack(alignment: .bottom) {
                    
                    Rectangle()
                        .foregroundColor(Color(red: 0.82, green: 0.35, blue: 0.09))
                        .frame(width: UIScreen.main.bounds.width, height: 100)
                    
                    
                    Text("POINTS PROGRAM")
                        .font(Font.custom("Viga-Regular", size: 25)).bold()
                        .foregroundStyle(.white)
                        .padding(.top, 20)
                        .padding()
                }
                
            ScrollView {
                
                // CIRCULAR PROGRESS
                ZStack {
                    
                    
                    CircularProgessView(vm: vm, progress: Double( currentMonth > 0 && currentMonth < 6 ? vm.springPercentile : currentMonth > 5 && currentMonth < 9 ? vm.summerPercentile : vm.fallPercentile) / 100)
                        
                    
                    
                    VStack {
                        if vm.gettingPoints
                        {
                            Text("Loading")
                                .font(.title)
                                .bold()
                            Text("Points...")
                                .font(.title)
                                .bold()
                        }
                        else
                        {
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
                    
                    PointsUI(points: vm.fallPoints, semester: "Fall", percent: vm.fallPercentile, gradient: fallGradient)
                    
                    PointsUI(points: vm.springPoints, semester: "Spring", percent: vm.springPercentile, gradient: springGradient)
                    
                    PointsUI(points: vm.summerPoints, semester: "Summer", percent: vm.summerPercentile, gradient: summerGradient)
                    
                }
                .padding(.vertical)
                
                
                VStack(spacing: 35) {
                    ForEach(keys, id: \.self) { key in
                        if !(vm.categorizedEvents[key]?.isEmpty ?? true)
                        {
                            TableView(vm: vm, title: key)
                        }
                    }
                }
                .padding()
                .padding(.bottom, 150)
                    
            }
            .padding(.top, -8)
        }
        .sheet(isPresented: $redeem, content: {
            RedeemView(vm: vm)
        })
        .ignoresSafeArea()
        .background(Color("darkBlue"))
        .onAppear(perform: {
            vm.gettingPoints = vm.points == 0
            vm.gettingEvents = true
            vm.setShpeitoPoints()
            vm.setShpeitoPercentiles()
            vm.getShpeitoPoints()
            vm.getUserEvents(coreEvents: coreEvents, viewContext: viewContext)
            CoreFunctions().editUserInCore(users: user, viewContext: viewContext, shpeito: vm.shpeito)
        })
        
        
    }
    
    
    // Function to return string with ordinal as a suffix
    
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
    PointsView(vm: PointsViewModel(shpeito: SHPEito()))
    .preferredColorScheme(.light)
}
