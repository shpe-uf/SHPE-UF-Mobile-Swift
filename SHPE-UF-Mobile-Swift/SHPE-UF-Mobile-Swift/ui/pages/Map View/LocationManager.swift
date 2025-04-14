//
//  LocationManager.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by Matthew Segura on 12/21/24.
//
/// A class responsible for managing the user's location.
///
/// `LocationManager` utilizes `CLLocationManager` to request location services and update the user's location.
/// It conforms to `ObservableObject` to allow SwiftUI views to react to location changes.
///
import SwiftUI
import CoreLocation

/// Manages location services and provides updates on the user's location.
///
/// `LocationManager` utilizes `CLLocationManager` to request location services
/// and update the user's location. It handles authorization requests and
/// provides the current user location to other components in the app.
///
/// # Example
/// ```swift
/// let locationManager = LocationManager()
/// if locationManager.isAuthorized {
///     // Access user's location
///     if let location = locationManager.userLocation {
///         print("User is at: \(location.coordinate.latitude), \(location.coordinate.longitude)")
///     }
/// }
/// ```
class LocationManager : NSObject, CLLocationManagerDelegate, ObservableObject {
    /// The user's current location
    @Published var userLocation: CLLocation?
    
    /// The location manager instance responsible for handling location services
    private let manager = CLLocationManager()
    
    /// A boolean indicating whether the app has location authorization
    var isAuthorized = false
    
    /// Initializes the `LocationManager` and starts location services
    override init(){
        super.init()
        manager.delegate = self
        startLocationServices()
    }
    
    /// Starts location services by checking authorization status.
    ///
    /// If authorization is granted, updates `isAuthorized` to `true`. Otherwise, it requests authorization
    func startLocationServices(){
        if manager.authorizationStatus == .authorizedAlways || manager.authorizationStatus == .authorizedWhenInUse{
            isAuthorized = true
        }
        else{
            isAuthorized = false
            manager.requestWhenInUseAuthorization()
        }
    }
    
    /// Updates the user's location when new location data is available.
    /// - Parameters:
    ///   - manager: The `CLLocationManager` instance.
    ///   - locations: An array of `CLLocation` objects representing location updates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations.last
    }
    
    /// Handles changes in location authorization status.
    /// - Parameter manager: The `CLLocationManager` instance
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus{
        case .authorizedAlways,.authorizedWhenInUse:
            isAuthorized = true
            manager.requestLocation()
        case .notDetermined:
            isAuthorized = false
            manager.requestWhenInUseAuthorization()
        case .denied:
            isAuthorized = false
            print("access denied")
        default:
            isAuthorized = true
            startLocationServices()
        }
    }
    
    /// Handles errors that occur while trying to obtain location updates.
    /// - Parameters:
    ///   - manager: The `CLLocationManager` instance.
    ///   - error: The error encountered during location updates
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print(error.localizedDescription)
    }

}
