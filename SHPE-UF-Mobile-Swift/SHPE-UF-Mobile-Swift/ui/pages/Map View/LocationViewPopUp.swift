//
//  LocationViewPopUp.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by Daniel Parra on 12/29/24.
//


/// A SwiftUI view that displays a popup for location details and routing options.
///
/// `LocationViewPopUp` provides an interactive interface for displaying a selected location
/// with routing options, estimated travel time, and user-selected transportation modes.
/// The popup can be dragged up and down to adjust its visibility.
///
/// - Requires: `SwiftUI`, `MapKit`
///
/// ## Overview
/// This view presents the `LocationDetailView` in a draggable popup format.
/// Users can:
/// - View detailed location information.
/// - Toggle route visibility.
/// - Select a transportation type.
/// - See estimated travel time.
///
/// ## Behavior
/// - The popup can be dragged up or down to adjust its position.
/// - If dragged upward beyond a threshold, it resets to a fully open position.
/// - If dragged downward beyond a threshold, it moves to a lower fixed position
///
import SwiftUI
import MapKit

/// A popup view displaying location details and route information.
struct LocationViewPopUp: View {
    /// The selected placemark representing the location.
    @Binding var placemark: MTPlacemark?
    
    /// A boolean flag indicating whether to show the route.
    @Binding var showRoute: Bool
    
    /// The estimated travel interval to the destination.
    @Binding var travelInterval: TimeInterval?
    
    /// The selected mode of transport.
    @Binding var transportType: MKDirectionsTransportType
    
    /// The coordinate of the destination.
    @Binding var destinationCoordinate: CLLocationCoordinate2D?
    
    /// The camera position for the map view.
    @Binding var cameraPosition: MapCameraPosition
    
    /// The currently displayed map region.
    @Binding var region: MKCoordinateRegion
    
    /// The destination represented as an `MKMapItem` for routing.
    @Binding var routeDestination: MKMapItem?
    
    /// The calculated route to the destination.
    @Binding var route: MKRoute?
    
    /// The drag offset while interacting with the popup.
    @State private var dragOffset:CGFloat = 0
    
    /// The current vertical offset of the popup.
    @State private var currentOffset:CGFloat = 0
    
    var body: some View {
        ZStack
        {
            VStack
            {
                LocationDetailView(destinationCoordinate: $destinationCoordinate,
                                   selectedPlacemark: placemark,
                                   showRoute: $showRoute,
                                   widgetOffset: $currentOffset,
                                   travelInterval : $travelInterval,
                                   transportType : $transportType,
                                   cameraPosition: $cameraPosition,
                                   region: $region,
                                   routeDestination: $routeDestination,
                                   route: $route
                )
            }
            .zIndex(999)
            .background(.whiteBox)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .frame(maxWidth: .infinity, minHeight: 450 + (currentOffset < 0 ? -1 * currentOffset : 0))
            .offset(y: UIScreen.main.bounds.height*0.45 + currentOffset)
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        dragOffset = gesture.translation.height // Track the drag offset
                        withAnimation {
                            currentOffset = dragOffset
                        }
                    }
                    .onEnded { _ in
                        // Calculate the final position
                        withAnimation {
                            if dragOffset < -10 {
                                // Move to the upper fixed position
                                currentOffset = 0
                            } else if dragOffset > 10 {
                                // Move to the lower fixed position
                                currentOffset = 260
                            }
                            
                            // Reset the drag offset
                            dragOffset = 0
                        }
                    }
            )
        }
        .ignoresSafeArea()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

//#Preview {
//    LocationViewPopUp()
//}
