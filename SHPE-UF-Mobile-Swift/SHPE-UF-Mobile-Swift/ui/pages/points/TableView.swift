//
//  TableView.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by David Denis on 2/15/24.
//

import SwiftUI


struct TableView: View {
    
    @StateObject var vm : PointsViewModel
    
    var title: String = "General Body Meeting"
    
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            
            VStack {
                Text(title.uppercased())
                    .font(.system(size: 40)).italic().bold()
                    .foregroundColor(Color(red: 0.82, green: 0.35, blue: 0.09))
                    
                
                
            }
            
            VStack {
                
                
                ZStack(alignment: .topLeading) {
                    
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 370, height: 50)
                        .background(Color(red: 0.85, green: 0.85, blue: 0.85))
                        .overlay(
                            
                            Rectangle()
                                .fill(Color.black)
                                .frame(width: 370, height: 1),
                            
                            
                            alignment: .bottom
                            
                        )
                    
                    
                    VStack(spacing: 0) {
                        HStack {
                            Text("EVENT")
                                .font(Font.custom("Univers LT Std", size: 23))
                                .foregroundColor(Color(red: 0, green: 0.18, blue: 0.31))
                                .frame(width: 80, height: 50)
                                .padding(.horizontal, 15)
                            
                            
                            
                            Text("DATE")
                                .font(Font.custom("Univers LT Std", size: 23))
                                .foregroundColor(Color(red: 0, green: 0.18, blue: 0.31))
                                .frame(width: 90, height: 50)
                                .padding(.horizontal, 15)
                            
                            Text("POINTS")
                                .font(Font.custom("Univers LT Std", size: 23))
                                .foregroundColor(Color(red: 0, green: 0.18, blue: 0.31))
                                .padding(.horizontal, 15)
                            
                        }
                        
                        
                        
                        
                        
                        ForEach(vm.categorizedEvents[title] ?? [], id: \.self) { event in
                            
                            SingleEventView(last: vm.categorizedEvents[title]?.last?.name == event.name, name: event.name, date: formattedDate(date: event.date), points: event.points)
                        }
                        
                        
                        
                        
                        
                    }
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .overlay(
                
                RoundedRectangle(cornerRadius: 15)
                    .stroke(lineWidth: 1)
                
            )
            
        }
    }
    
    
    
    func formattedDate(date: Date) -> String {
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy" // Customize the date format here
        return dateFormatter.string(from: date)
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        TableView(vm: PointsViewModel(shpeito:
                                        SHPEito(
                                                username: "dvera0322",
                                                password: "",
                                                remember: "true",
                                                base64StringPhoto: "",
                                                firstName: "David",
                                                lastName: "Denis",
                                                year: "Sophmore",
                                                major: "Computer Science",
                                                id: "642f7f80e8839f0014e8be9b",
                                                token: "",
                                                confirmed: true,
                                                updatedAt: "",
                                                createdAt: "",
                                                email: "denisdavid@ufl.edu",
                                                gender: "Male",
                                                ethnicity: "Hispanic",
                                                originCountry: "Cuba",
                                                graduationYear: "2026",
                                                classes: ["Data Structures", "Discrete Structures"],
                                                internships: ["Apple"],
                                                links: ["google.com"],
                                                fallPoints: 20,
                                                summerPoints: 17,
                                                springPoints: 30,
                                                points: 67,
                                                fallPercentile: 93,
                                                springPercentile: 98,
                                                summerPercentile: 78)
                                     ))
    }
}
