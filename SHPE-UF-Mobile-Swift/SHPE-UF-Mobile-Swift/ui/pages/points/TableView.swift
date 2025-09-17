//
//  TableView.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by David Denis on 2/15/24.
//

import SwiftUI

/// A view that displays a categorized table of user event data, including event name, date, and points earned.
///
/// This view fetches a list of events from a `PointsViewModel`, organized by event category (e.g., "General Body Meeting").
/// Each event is displayed as a row in the table with three columns: Event name, date, and point value.
///
/// The table includes a header row, and each section is styled with rounded corners and background colors.
///
/// - Parameters:
///   - vm: A `PointsViewModel` that contains categorized event data to be displayed.
///   - title: The category title for the events (default is `"General Body Meeting"`).
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
                            
                            SingleEventView(
                                last: vm.categorizedEvents[title]?.last?.name == event.name,
                                name: event.name,
                                date: formattedDate(date: event.date),
                                points: event.points
                            )
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
    
    
    /// Formats a `Date` object into a string with the format `"MM/dd/yyyy"`.
    ///
    /// This utility function uses `DateFormatter` to convert a `Date`
    /// into a human-readable string in the U.S. month/day/year format.
    ///
    /// - Parameter date: The `Date` to be formatted.
    /// - Returns: A `String` representing the formatted date.
    ///
    /// ## Example:
    /// ```swift
    /// let today = Date()
    /// let formatted = formattedDate(date: today)
    /// // e.g., "04/13/2025"
    /// ```
    func formattedDate(date: Date) -> String {
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy" // Customize the date format here
        return dateFormatter.string(from: date)
        
    }
    
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        TableView(vm: PointsViewModel(shpeito:
//                                        SHPEito()
//                                     ))
//    }
//}
