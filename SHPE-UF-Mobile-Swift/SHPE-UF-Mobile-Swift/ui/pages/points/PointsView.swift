//
//  PointsView.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by Jesus Lopez on 10/23/23.
//

import SwiftUI

struct PointsView: View {
    
    @StateObject var vm : PointsViewModel
    
    @State private var redeem = false;
    
    // REFACTOR
    
    var fallGradient : LinearGradient = LinearGradient(stops: [Gradient.Stop(color: Color(red: 0.04, green: 0.13, blue: 0.35), location: 0.00),
                                                              Gradient.Stop(color: Color(red: 0.18, green: 0.38, blue: 0.62), location: 1.00)],
                                                       startPoint: UnitPoint(x: 0.5, y: 0),
                                                       endPoint: UnitPoint(x: 0.5, y: 1))
    
    var springGradient : LinearGradient = LinearGradient(stops: [Gradient.Stop(color: Color(red: 0.04, green: 0.44, blue: 0.73), location: 0.00),
                                                                 Gradient.Stop(color: Color(red: 0.52, green: 0.8, blue: 1), location: 1.00)],
                                                          startPoint: UnitPoint(x: 0.5, y: 0),
                                                          endPoint: UnitPoint(x: 0.5, y: 1))
    
    var summerGradient : LinearGradient = LinearGradient(stops: [Gradient.Stop(color: Color(red: 0.6, green: 0.12, blue: 0.08), location: 0.00),
                                                                 Gradient.Stop(color: Color(red: 0.97, green: 0.46, blue: 0.3), location: 1.00)],
                                                          startPoint: UnitPoint(x: 0.5, y: 0),
                                                          endPoint: UnitPoint(x: 0.5, y: 1))
        
    
    
    var body: some View {
        
        ScrollView {
            
            ZStack {
                
                VStack(spacing: 15) {
                    
                    
                    ZStack {
                        
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: .infinity, height: 100)
                            .background(Color(red: 0.82, green: 0.35, blue: 0.09))
                            .ignoresSafeArea()
                        HStack {
                            
                            Text("POINTS PROGRAM")
                                .font(.title).bold()
                                .foregroundStyle(.white)
                            
                            
                            Image("shpe_logo")
                                .resizable()
                                .frame(width: UIScreen.main.bounds.width * 0.27, height: UIScreen.main.bounds.width * 0.27)
                            
                        }
                        .padding(.vertical)
                    }
                    
                    // CIRCULAR PROGRESS
                    ZStack {
                        CircularProgessView(progress: Double(vm.springPercentile) / 100)
                        
                        VStack {
                            Text("SPRING:")
                                .font(.title)
                                .bold()
                            Text("\(stringWithOrdinalSuffix(from : vm.springPercentile))")
                                .font(.title)
                                .bold()
                            Text("Percentile")
                                .font(.title)
                                .bold()
                        }
                    }
                    
                    Spacer()
                    
                    
                    // REDEEM BUTTON
                    
                    Button {
                        redeem.toggle()
                    } label: {
                        ReedemPointsButton()
                            .foregroundColor(.black)
                    }
                    .padding(.bottom)
                    
                    
                    // DISPLAY POINTS
                    VStack {
                        PointsUI(points: vm.fallPoints, semester: "Fall", percent: vm.fallPercentile, gradient: fallGradient)
                      
                        PointsUI(points: vm.springPoints, semester: "Spring", percent: vm.springPercentile, gradient: springGradient)
                       
                        PointsUI(points: vm.summerPoints, semester: "Summer", percent: vm.summerPercentile, gradient: summerGradient)
                            
                    }
                    
                  
                }
                
            }
            .sheet(isPresented: $redeem, content: {
                ReedemView(vm: vm)
            })
            .backgroundStyle(.black)
            .ignoresSafeArea()
            
        }
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
    PointsView(vm: PointsViewModel(shpeito:
                                    SHPEito(
                                        id: "642f7f80e8839f0014e8be9b",
                                        name: "David Denis",
                                        points: 0,
                                        fallPercentile: 23,
                                        springPercentile: 75,
                                        summerPercentile: 0,
                                        fallPoints: 67,
                                        springPoints: 0,
                                        summerPoints: 0,
                                        username: "dparra1"
                                    )
                                  ))
    .preferredColorScheme(.light)
}
