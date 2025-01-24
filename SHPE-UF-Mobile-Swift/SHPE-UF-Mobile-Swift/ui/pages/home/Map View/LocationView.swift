//
//  MapView.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by Matthew Segura on 11/14/24.
//

import SwiftUI
import MapKit
import SwiftData

struct LocationView: View {
    
    var location: String // The event location to display
    var event : String
    @Binding var showView: String // For dismissing the view
    @Environment(\.colorScheme) var colorScheme
    
    //Location coordinates
    @State private var destinationCoordinate: CLLocationCoordinate2D?
    @State private var isLocationLoaded = false
    @State private var region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 29.6516, longitude: -82.3248), // Default: Gainesville
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
    @State private var cameraPosition: MapCameraPosition = .automatic
    
    //User location & Permission
    @State private var selectedPlacemark: MTPlacemark? = AppViewModel.appVM.placemark
    
    // To trigger the sheet
    @State private var triggerSheet = false
    
    //Route
    @State private var showRoute = false
    @State private var routeDisplaying = false
    @State private var route: MKRoute?
    @State private var routeDestination: MKMapItem?
    @State private var travelInterval: TimeInterval?
    @State private var transportType = MKDirectionsTransportType.automobile
    @State private var showSteps = false
    
    //MapControls
    @Namespace private var mapScope
    
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
    //Genuinely hate that this is  needed to select markers
    private func makeMarkers(event: String,address: String, location : CLLocationCoordinate2D) ->[MTPlacemark]{
        let marker = MTPlacemark(name: event, address: address, latitude: location.latitude, longitude: location.longitude)
        return [marker]
    }
    

}


