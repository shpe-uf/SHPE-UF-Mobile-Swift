//
//  MapManager.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by Matthew Segura on 12/22/24.
//

import SwiftData
import MapKit
/// A utility enum for handling map-related functions
///
enum MapManager{
    /// Converts a distance in meters to a localized string representation.
    ///
    /// This method formats a given distance based on the user's locale.
    /// It returns the distance in meters for metric system users and in yards for users of the imperial system.
    ///
    /// - Parameter meters: The distance in meters.
    /// - Returns: A string representation of the distance in the appropriate unit.
    static func distance(meters: Double) -> String {
        let userLocale = Locale.current
        let formatter = MeasurementFormatter()
        var options: MeasurementFormatter.UnitOptions = []
        options.insert(.providedUnit)
        options.insert(.naturalScale)
        formatter.unitOptions = options
        let meterValue = Measurement(value: meters, unit: UnitLength.meters)
        let yardsValue = Measurement(value: meters, unit: UnitLength.yards)
        return formatter.string(from: userLocale.measurementSystem == .metric ? meterValue : yardsValue)
    }
}
