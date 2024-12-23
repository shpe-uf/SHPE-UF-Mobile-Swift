//
//  Destination.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by Matthew Segura on 12/20/24.
//
import MapKit
import SwiftData

@Model
class Destination {
    
    var name: String
    var latitude: Double?
    var longitude: Double?
    var latitudeDelta: Double?
    var longitudeDelta: Double?
    
    @Relationship(deleteRule: .cascade)
    var placemark: [MTPlacemark] = []
    
    init(name: String, latitude: Double? = nil, longitude: Double? = nil, latitudeDelta: Double? = nil, longitudeDelta: Double? = nil) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.latitudeDelta = latitudeDelta
        self.longitudeDelta = longitudeDelta
    }
    
    var region: MKCoordinateRegion? {
        if let latitude,let longitude, let latitudeDelta,let longitudeDelta{
            return MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
                span: MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta:longitudeDelta)
                
            )
        }else{
            return nil
        }
    }
}

extension Destination{
    @MainActor
    static var preview: ModelContainer{
        let container = try! ModelContainer(
            for: Destination.self,
            configurations:  ModelConfiguration(
                isStoredInMemoryOnly: true
            )
        )
        let gainesville = Destination(
            name: "UF Campus",
            latitude: 29.6516,
            longitude: -82.3248,
            latitudeDelta: 0.05,
            longitudeDelta: 0.05
        )
        container.mainContext.insert(gainesville)
//        var placemarks:[MTPlacemark]{
//            [
//                MTPlacemark(name: <#T##String#>, address: <#T##String#>, latitude: <#T##Double#>, longitude: <#T##Double#>)
//            ]
//        }
        return container

        
    }
}
