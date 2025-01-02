//
//  LocationViewPopUp.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by Daniel Parra on 12/29/24.
//

import SwiftUI
import MapKit

struct LocationViewPopUp: View {
    @Binding var placemark: MTPlacemark?
    @Binding var showRoute: Bool
    @Binding var travelInterval: TimeInterval?
    @Binding var transportType: MKDirectionsTransportType
    @Binding var destinationCoordinate: CLLocationCoordinate2D?
    
    @State private var dragOffset:CGFloat = 0
    @State private var currentOffset:CGFloat = 0
    
    var body: some View {
        ZStack
        {
            VStack
            {
                LocationDetailView(destinationCoordinate: destinationCoordinate,
                                   selectedPlacemark: placemark,
                                   showRoute: $showRoute,
                                   widgetOffset: $currentOffset,
                                   travelInterval : $travelInterval,
                                   transportType : $transportType)
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
