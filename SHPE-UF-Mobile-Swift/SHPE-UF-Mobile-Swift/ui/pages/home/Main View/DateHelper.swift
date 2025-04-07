//
//  DateHelper.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by Matthew Segura on 3/22/24.
//
import SwiftUI

struct DateHelper {
    /// Returns the current month as a string.
    ///
    /// This function uses a `DateFormatter` to get the current date and format it
    /// to return the full month name (e.g., "March").
    ///
    /// - Returns: A string representing the current month.
    ///
    ///# Example
    /// ```swift
    /// let currentMonth = getCurrentMonth()
    /// print(currentMonth) // Output: "March" (depending on the current date)
    /// ```
    func getCurrentMonth() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter.string(from: Date())
    }
    //Gets the month of an event as a string
    func getMonth(for date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter.string(from: date)
    }

    // Gets the time in hour and minutes AM/PM format
    func getTime(for date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        return dateFormatter.string(from: date)
    }

    /// Return a formatted string of a full date from `Date` object
    ///
    ///This is a function that returns an event `Date` object into a string in the
    ///format of `MMM dd, yyy`(e.g Mar 06, 2025)
    ///
    /// ## Example
    /// ```swift
    /// let date = Date()
    /// let formattedDate = getDayFull(for: date)
    /// print(formattedDate) //Formatted day of "date" ("Mar 06, 2025")
    /// ```
    func getDayFull(for date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        return dateFormatter.string(from: date)
    }

    // Gets the day abbreviation (e.g., Mon, Tue)
    func getDayAbbreviation(for date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E"
        return dateFormatter.string(from: date)
    }

    // Gets the day number from a date
    func getDayNumber(for date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"
        return dateFormatter.string(from: date)
    }
}
