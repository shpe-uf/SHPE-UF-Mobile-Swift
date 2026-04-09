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
    var name: String = "Fall GBM 6"
    var date: String = "11/08/2023"
    var points: Int = 1
    
    var body: some View {
        
        VStack(spacing: 0) {
                HStack(alignment: .center, spacing: 15) {
                    
                    VStack(alignment: .leading) {
                        Text(name)
                            .multilineTextAlignment(TextAlignment.leading)
                            .foregroundStyle(.primary)
                        
                        Text(date)
                            .foregroundStyle(.secondary)
                    }
                    
                    Spacer()
                    
                    Text("\(points) \(points == 1 ? "point" : "points")")
                
                    Image(systemName: "person.3.fill")
                        .frame(width: 20, height: 20)
                        .foregroundStyle(Color(.systemBlue))
                }
                .font(Font.custom("Viga-Regular", size: 15))
                .padding()
        }
    }
}

#Preview {
    SingleEventView()
}

