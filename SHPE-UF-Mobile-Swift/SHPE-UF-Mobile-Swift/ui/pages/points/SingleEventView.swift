//
//  SingleEventView.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by David Denis on 2/15/24.
//

import SwiftUI

/// A row-style view that displays a single SHPE event with its name, date, and point value.
///
/// `SingleEventView` is used to render a consistent UI row for event history,
/// including optional dividers for visual separation. It displays the event's
/// title, formatted date, and associated points earned.
///
/// - Parameters:
///   - last: A `Bool` indicating whether this is the last item in a list. When `true`, the bottom divider is hidden.
///   - name: A `String` representing the title of the event. Supports multi-line formatting.
///   - date: A `String` representing the date of the event.
///   - points: An `Int` indicating the number of points awarded for attending the event.
///
/// ## Appearance:
/// - Width: 370
/// - Height: 75
/// - Background: Light gray
/// - Font: Univers LT Std, size 15
/// - Divider shown unless `last` is `true`
///
/// ## Example:
/// ```swift
/// SingleEventView(name: "Fall GBM\n6", date: "11/08/2023", points: 1)
/// ```
struct SingleEventView: View {
    
    var last: Bool = false
    
    var name: String = "Fall GBM\n6"
    var date: String = "11/08/2023"
    var points: Int = 1
    
    var body: some View {
        
        VStack(spacing: 0) {
        
            ZStack(alignment: .center) {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 370, height: 75)
                    .background(Color(red: 0.93, green: 0.93, blue: 0.93))
                
                
                HStack {
                    Text(name)
                        .font(Font.custom("Univers LT Std", size: 15))
                        .foregroundColor(Color(red: 0, green: 0.18, blue: 0.31))
                        .padding(.leading, 20)
                        .frame(width: 100, height: 50, alignment: .leading)
                        .padding(.trailing)
                    
                    
                    
                    Text(date)
                        .font(Font.custom("Univers LT Std", size: 15))
                        .foregroundColor(Color(red: 0, green: 0.18, blue: 0.31))
                        .frame(width: 100, height: 50)
                        .padding(.leading)
                       
                    
                    
                    
                    Text("\(points)")
                        .font(Font.custom("Univers LT Std", size: 15))
                        .foregroundColor(Color(red: 0, green: 0.18, blue: 0.31))
                        .frame(width: 100, height: 50)
                        .padding(.leading)
                    
                }
                
            }
            
            Divider()
                .frame(width: 370, height: last ? 0 : 1)
                .overlay(.black)
                
           
        }
        
    }
}

#Preview {
    SingleEventView()
}

