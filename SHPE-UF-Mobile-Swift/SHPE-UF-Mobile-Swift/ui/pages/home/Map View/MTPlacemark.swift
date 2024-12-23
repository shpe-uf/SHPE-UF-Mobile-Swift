//
//  MTP.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by Matthew Segura on 12/20/24.
//
import SwiftData
import MapKit

@Model
class MTPlacemark{
    var name: String
    var address:String
    var latitude: Double
    var longitude: Double

    
    init(name: String, address: String, latitude: Double, longitude: Double) {
        self.name = name
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
    }
}
