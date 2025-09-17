//
//  Constants.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by Matthew Segura on 3/22/24.
//

import SwiftUI

/// A centralized collection of design constants used throughout the application.
///
/// This struct provides:
/// 1. Consistent color palette for the entire app
/// 2. Centralized color management
/// 3. Support for both light and dark modes
///
/// ## Usage Guidelines
/// - Use these constants instead of hard-coded colors
/// - For color scheme-dependent values, use `.adaptive` modifier
/// - Add new constants here when new colors are needed
///
/// ## Color Palette
/// - Primary Colors: orange, blue, teal
/// - Secondary Colors: grey, green, yellow, pink
/// - UI Colors: background, text, icons
struct Constants {
    static let BackgroundColor: Color = Color(red: 0.93, green: 0.93, blue: 0.93) // Default background color
    static let darkModeBackground: Color = Color(red: 0, green: 0.12, blue: 0.21) // Dark blue for dark mode
    static let DescriptionHeaderColor: Color = Color(red: 0, green: 0.12, blue: 0.21) // Color for headers in descriptions
    static let lightTextColor: Color = Color.white // Text color for dark mode
    static let NotificationsSelectIcon: Color = Color(red: 0.72, green: 0.72, blue: 0.72) // Color for notification icons
    static let DescriptionTextColor: Color = Color(red: 0.25, green: 0.25, blue: 0.25) // Color for text in descriptions
    static let DashedLineColor: Color = Color.black // Color for dashed lines
    static let DayTextColor: Color = Color(red: 0.42, green: 0.42, blue: 0.42) // Text color for days
    static let DayNumberTextColor: Color = Color(red: 0.26, green: 0.26, blue: 0.26) // Text color for day numbers
    static let orange: Color = Color(red: 0.82, green: 0.35, blue: 0.09) // Custom orange color
    static let teal: Color = Color(red: 0.26, green: 0.46, blue: 0.48) // Custom teal color
    static let blue: Color = Color(red: 0, green: 0.44, blue: 0.76) // Custom blue color
    static let grey: Color = Color(red: 0.23, green: 0.23, blue: 0.23) // Custom grey color
    static let green: Color = Color(red: 0.17, green: 0.34, blue: 0.09) // Custom green color
    static let yellow: Color = Color(red: 0.69, green: 0.54, blue: 0) // Custom yellow color
    static let pink: Color = Color(red: 0.75, green: 0.29, blue: 0.51) // Custom pink color
    static let iconColor: Color = Color.black // Icon color for light mode
    static let darkModeIcon: Color = Color.white // Icon color for dark mode
}
