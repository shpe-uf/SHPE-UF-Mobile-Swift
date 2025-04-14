//
//  Destination.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by Matthew Segura on 12/20/24.
//
import MapKit
import SwiftData

/// A model representing a destination with optional geographic coordinates.
///
/// The `Destination` class stores location-related information, including
/// latitude, longitude, and coordinate span. It also manages a relationship
/// to `MTPlacemark` instances.
///
/// # Example
/// ```swift
/// let campus = Destination(
///     name: "UF Campus",
///     latitude: 29.6516,
///     longitude: -82.3248,
///     latitudeDelta: 0.05,
///     longitudeDelta: 0.05
/// )
/// ```
@Model
class Destination {
    /// The name of the destination
    var name: String
    /// The latitude of the destination
    var latitude: Double?
    /// The longitude of the destination
    var longitude: Double?
    /// The latitude span for the coordinate region
    var latitudeDelta: Double?
    /// The longitude span for the coordinate region
    var longitudeDelta: Double?
    
    /// An array of placemarks associated with this destination.
    ///
    /// This relationship is configured with a cascade delete rule,
    /// meaning associated placemarks will be deleted when the destination is removed.
    ///
    @Relationship(deleteRule: .cascade)
    var placemark: [MTPlacemark] = []
    /**
     Initializes a new `Destination` instance.
     
     - Parameters:
       - name: The name of the destination.
       - latitude: The latitude of the destination. Defaults to `nil`.
       - longitude: The longitude of the destination. Defaults to `nil`.
       - latitudeDelta: The latitude span for the region. Defaults to `nil`.
       - longitudeDelta: The longitude span for the region. Defaults to `nil`.
     */
    init(name: String, latitude: Double? = nil, longitude: Double? = nil, latitudeDelta: Double? = nil, longitudeDelta: Double? = nil) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.latitudeDelta = latitudeDelta
        self.longitudeDelta = longitudeDelta
    }
    /**
     Computes and returns the coordinate region if all necessary values are available.
     
     - Returns: An `MKCoordinateRegion` if latitude, longitude, latitudeDelta, and longitudeDelta are set; otherwise, `nil`.
     */
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
    /**
     Provides a preview `ModelContainer` for SwiftUI previews.
     
     This container is stored in memory and contains a sample destination.
     */
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
