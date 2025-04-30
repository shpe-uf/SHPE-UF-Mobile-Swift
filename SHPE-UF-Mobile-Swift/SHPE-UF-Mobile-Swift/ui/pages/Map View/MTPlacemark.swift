//
//  MTP.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by Matthew Segura on 12/20/24.
//
import SwiftData
import MapKit

@Model
/// A model representing a geographical location with a name, address, and coordinates.
class MTPlacemark{
    var name: String
    var address:String
    var latitude: Double
    var longitude: Double

    /// Initializes a new placemark with the given details.
    /// - Parameters:
    ///   - name: The name of the location.
    ///   - address: The address of the location.
    ///   - latitude: The latitude coordinate.
    ///   - longitude: The longitude coordinate.
    init(name: String, address: String, latitude: Double, longitude: Double) {
        self.name = name
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
    }
}
