//
//  LocationManager.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by Matthew Segura on 12/21/24.
//

import SwiftUI
import CoreLocation

class LocationManager : NSObject, CLLocationManagerDelegate, ObservableObject {
    @Published var userLocation: CLLocation?
    private let manager = CLLocationManager()
    var isAuthorized = false
    
    override init(){
        super.init()
        manager.delegate = self
        startLocationServices()
    }
    func startLocationServices(){
        if manager.authorizationStatus == .authorizedAlways || manager.authorizationStatus == .authorizedWhenInUse{
            isAuthorized = true
        }
        else{
            isAuthorized = false
            manager.requestWhenInUseAuthorization()
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations.last
    }
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
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print(error.localizedDescription)
    }

}
