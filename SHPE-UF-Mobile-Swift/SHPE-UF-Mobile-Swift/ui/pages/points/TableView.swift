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
    
    let events: [UserEvent]
    var title: String = "General Body Meeting"
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            VStack {
                Text(title.uppercased())
                    .font(Font.custom("Viga-Regular", size: 20))
                    .foregroundStyle(Constants.orange)
            }
            .padding()
        
            VStack(spacing: 0) {
                ForEach(events, id: \.self) { event in
                    SingleEventView(
                        name: event.name,
                        date: formattedDate(date: event.date),
                        points: event.points
                    )
                }
            }
        }
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

