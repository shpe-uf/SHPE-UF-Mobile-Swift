//
//  MapManager.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by Matthew Segura on 12/22/24.
//

import SwiftData
import MapKit

enum MapManager{
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
