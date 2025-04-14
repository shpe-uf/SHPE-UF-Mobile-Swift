//
//  MapView.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by Matthew Segura on 11/14/24.
//

import SwiftUI
import MapKit
import SwiftData

/// A view that displays a map with event location details, user positioning, and route previews.
///
/// `LocationView` provides a map interface that shows:
/// - The location of an event
/// - The user's current position
/// - Optional route visualization between user and event
/// - A location detail popup for additional information
///
/// The view handles geocoding of addresses and manages the map's camera position.
///
/// # Example
/// ```swift
/// LocationView(
///     location: "123 Main St, Gainesville, FL",
///     event: "SHPE Meeting",
///     showView: $viewState
/// )
/// ```
struct LocationView: View {
    // MARK: - Properties
        
    /// The event location as an address string.
    var location: String // The event location to display
    
    /// The name of the event
    var event : String
    /// A binding to control dismissing the view
    @Binding var showView: String // For dismissing the view
    
    /// Detects the current color scheme (light/dark mode)
    @Environment(\.colorScheme) var colorScheme
    
    // MARK: - State Variables
    
    /// Location coordinates for the destination
    @State private var destinationCoordinate: CLLocationCoordinate2D?
    
    /// Flag indicating whether the location has been successfully loaded
    @State private var isLocationLoaded = false
    
    /// The map's region, with Gainesville as the default center
    @State private var region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 29.6516, longitude: -82.3248), // Default: Gainesville
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
    
    /// The map camera position, initially set to automatic
    @State private var cameraPosition: MapCameraPosition = .automatic
    
    /// User location & Permission
    @State private var selectedPlacemark: MTPlacemark? = AppViewModel.appVM.placemark
    
    ///Flag to trigger the sheet
    @State private var triggerSheet = false
    
    // MARK: - Route & Navigation
        
    /// Flag to indicate whether a route should be displayed.
    @State private var showRoute = false
    
    /// Flag indicating whether the route is actively being displayed
    @State private var routeDisplaying = false
    
    /// Flag indicating whether the route is actively being displayed
    @State private var route: MKRoute?
    
    /// Destination map item for routing
    @State private var routeDestination: MKMapItem?
    
    /// Estimated travel time for the selected route
    @State private var travelInterval: TimeInterval?
    
    /// The selected mode of transportation (default: automobile)
    @State private var transportType = MKDirectionsTransportType.automobile
    
    /// Flag to indicate whether the route steps should be shown
    @State private var showSteps = false
    
    /// Namespace for controlling map-related animations
    @Namespace private var mapScope
    
    
    // MARK: - Body
    var body: some View {
        
        
        ZStack {
            
            VStack(spacing: 0){
                ZStack(alignment: .topLeading)
                {
                    
                    Map(position: $cameraPosition,selection: $selectedPlacemark, scope: mapScope)
                    {
                        UserAnnotation()
                        if let destination = destinationCoordinate {
                            let markers = makeMarkers(event: event,address: location, location: destination)
                            ForEach(markers){ marker in
                                if !showRoute{ // Before selecting preview route
                                    Group{
                                        Marker(coordinate: destination) {
                                            Label(event, systemImage: "star.fill")
                                        }
                                        .tint(.rorange)
                                    }
                                    .tag(marker)
                                }
                                else{
                                    if let routeDestination{
                                        Marker(item:routeDestination)
                                            .tint(.rorange)
                                        
                                    }
                                }
                                
                                
                            }
                            if let route, routeDisplaying{
                                MapPolyline(route.polyline)
                                    .stroke(.blue, lineWidth: 6)
                            }
                        }
                    }
                    .onAppear {
                        geocodeLocation()
                    }
                    .mapControls{
                        MapScaleView()
                    }
                    .task(id:selectedPlacemark){
                        if selectedPlacemark != nil{
                            routeDisplaying = false
                            showRoute = false
                            route = nil
                        }
                    }
                    .onChange(of: showRoute){
//                        selectedPlacemark = nil
                        if showRoute && route != nil
                        {
                            withAnimation{
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1)
                                {
                                    if let rect = route?.polyline.boundingMapRect{
                                        print(rect)
                                        
                                        let scaleFactor: Double = 1.2
                                        
                                        let newWidth = rect.size.width * scaleFactor
                                        let newHeight = rect.size.height * scaleFactor
                                        
                                        let deltaX = (newWidth - rect.size.width) / 2
                                        let deltaY = (newHeight - rect.size.height) / 2
                                        let newOrigin = MKMapPoint(x: rect.origin.x - deltaX, y: rect.origin.y - deltaY)
                                        
                                        let scaledRect = MKMapRect(origin: newOrigin, size: MKMapSize(width: newWidth, height: newHeight))
                                        
                                        routeDisplaying = true
                                        cameraPosition = .rect(scaledRect)
                                    }
                                }
                            }
                        }
                    }
                    .mapScope(mapScope)
                    
                    // Back button and preview header
                    header
                    
                    if selectedPlacemark != nil && isLocationLoaded
                    {
                        LocationViewPopUp(
                            placemark: $selectedPlacemark,
                            showRoute: $showRoute,
                            travelInterval: $travelInterval,
                            transportType: $transportType,
                            destinationCoordinate: $destinationCoordinate,
                            cameraPosition: $cameraPosition,
                            region: $region,
                            routeDestination: $routeDestination,
                            route: $route
                        )
                    }
                }
            }
        }
    }
    
    // MARK: - Header View
    private var header: some View{
        ZStack(alignment : .topLeading){
            VStack(spacing: 0){
                Rectangle()
                    .foregroundColor(.clear)
                    .background(Color(red: 0.82, green:0.35,blue:0.09).opacity(0.7))
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.0075)
                ZStack{
                    Rectangle()
                        .foregroundColor(.clear)
                        .background(colorScheme == .dark ? Constants.darkModeBackground : Constants.BackgroundColor)
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.11)
                    
                    Text("Route Preview")
                        .font(Font.custom("Viga-Regular", size: 24))
                        .padding(.top, 45)
                }
            }
            HStack {
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        AppViewModel.appVM.inMapView = false
                        showView = "EventInfoView"
                    }
                } label: {
                        
                    Image(systemName: "chevron.backward")
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(.whiteText)
                            .frame(width: UIScreen.main.bounds.width * 0.05, height: UIScreen.main.bounds.height * 0.025)
                }
                .padding(.horizontal, UIScreen.main.bounds.width * 0.05)
                Spacer()
            }
            .padding(.top, 65)
        }
        .ignoresSafeArea()
    }
    // MARK: - Geocoding Functions
    
    /// Converts an address string into a coordinate.
    ///
    /// - Parameters:
    ///   - addressString: The address to geocode
    ///   - completionHandler: A closure that receives the coordinate result or error
    func getCoordinate( addressString : String,
            completionHandler: @escaping(CLLocationCoordinate2D, NSError?) -> Void ) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(addressString) { (placemarks, error) in
            if error == nil {
                if let placemark = placemarks?[0] {
                    let location = placemark.location!
                        
                    completionHandler(location.coordinate, nil)
                    return
                }
            }
                
            completionHandler(kCLLocationCoordinate2DInvalid, error as NSError?)
        }
    }
    
    
    /// Converts the given address into coordinates and updates the map region.
    ///
    /// This method geocodes the location address and, upon success,
    /// updates the map region and creates a placemark for the location.
    private func geocodeLocation() {
            getCoordinate(addressString: location) { coordinate, error in
                guard error == nil else {
                    print("Geocoding failed: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                let offsetCoordinate = CLLocationCoordinate2D(
                                latitude: coordinate.latitude - 0.00025,
                                longitude: coordinate.longitude
                )
                withAnimation {
                    region = MKCoordinateRegion(
                        center: offsetCoordinate,
                        span: MKCoordinateSpan(latitudeDelta: 0.0015, longitudeDelta: 0.0015)
                    )
                    cameraPosition = .region(region)
                    destinationCoordinate = coordinate
                    isLocationLoaded = true
                    selectedPlacemark = MTPlacemark(name: event, address: location, latitude: offsetCoordinate.latitude, longitude: offsetCoordinate.longitude)
                }
            }
    }
    
    /// Creates a marker for the event location.
    ///
    /// - Parameters:
    ///   - event: The name of the event
    ///   - address: The address of the event
    ///   - location: The coordinate of the event
    /// - Returns: An array containing the created placemark
    private func makeMarkers(event: String,address: String, location : CLLocationCoordinate2D) ->[MTPlacemark]{
        let marker = MTPlacemark(name: event, address: address, latitude: location.latitude, longitude: location.longitude)
        return [marker]
    }
    

}


