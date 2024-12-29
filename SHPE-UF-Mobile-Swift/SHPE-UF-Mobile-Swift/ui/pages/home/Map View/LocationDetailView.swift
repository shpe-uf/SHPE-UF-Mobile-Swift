//
//  LocationDetailView.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by Matthew Segura on 12/21/24.
//
import SwiftUI
import MapKit
import SwiftData

struct LocationDetailView: View{
    @Environment(\.dismiss) private var dismiss
    var destinationCoordinate: CLLocationCoordinate2D?
    var selectedPlacemark : MTPlacemark?
    @Binding var showRoute: Bool
    @Binding var widgetOffset: CGFloat
    @Binding var travelInterval: TimeInterval?
    @Binding var transportType: MKDirectionsTransportType
    
    var travelTime: String?{
        guard let travelInterval else{return nil}
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.allowedUnits = [.hour,.minute]
        return formatter.string(from: travelInterval)
    }
    @State private var name = ""
    @State private var address = ""
    @State private var type =  MKDirectionsTransportType.automobile
    @State private var lookaroundScene: MKLookAroundScene?
    
    var body: some View{
        VStack{
            HStack{
                VStack(alignment: .leading){
                    HStack(alignment: .center)
                    {
                        Spacer()
                        RoundedRectangle(cornerRadius: 2)
                            .frame(width: 50,height: 4)
                            .background(.gray.opacity(0.5))
                        Spacer()
                    }
                    .frame(width:.infinity)
                    
                    Text(name)
                        .font(.title2)
                        .lineLimit(1)
                        .fontWeight(.semibold)
                    Text(address)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                        .fixedSize(horizontal: false, vertical: true)
                    if destinationCoordinate != nil{
                        
                        HStack{
                            Button{
                                transportType = .automobile // There is double as to show time when first appears and still keep binding variable updated for route type
                                type = .automobile
                            }label:{
                                Image(systemName:"car")
                                    .foregroundColor(type == .automobile ? .blue: .lorange)
                                    .imageScale(.large)
                            }
                            Button{
                                transportType = .walking
                                type = .walking
                            }label:{
                                Image(systemName:"figure.walk")
                                    .foregroundColor(type == .walking ? .blue : .lorange)
                                    .imageScale(.large)
                            }
                            
                            if let travelTime{
                                let prefix = transportType == .automobile ? "Driving" : "Walking"
                                Text("\(prefix) time: \(travelTime)")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            
                        }
                    }
                }
                
                
                
                Spacer()
//                Button{
//                    dismiss()
//                }label:{
//                    Image(systemName: "xmark.circle.fill")
//                        .imageScale(.large)
//                        .foregroundStyle(.gray)
//                }
                
            }
            if let lookaroundScene{
                LookAroundPreview(initialScene: lookaroundScene)
                    .frame(height:UIScreen.main.bounds.height * 0.2)
                    .padding()
            }else{
                ContentUnavailableView("No preview available", systemImage: "eye.slash")
                    .frame(height:UIScreen.main.bounds.height * 0.2)
                    .padding()
            }
            HStack{
                Spacer()
                if let destination = destinationCoordinate{
                    Button("Open in maps",systemImage: "map"){
                        if let selectedPlacemark{
                            let placemark = MKPlacemark(coordinate: destination)
                            let mapItem = MKMapItem(placemark: placemark)
                            mapItem.name = selectedPlacemark.name
                            mapItem.openInMaps()
                        }
                    }
                    .fixedSize(horizontal: true, vertical: false)
                    
                    Button("Show Route", systemImage: "location.north"){
                        showRoute.toggle()
                        widgetOffset = 260
                    }
                    .fixedSize(horizontal: true, vertical: false)
                }
            }
            .buttonStyle(.bordered)
            Spacer()
        }
        .padding()
        .task(id: selectedPlacemark){
            await fetchLookaroundPreview()
        }
        .onAppear{
            if let selectedPlacemark{
                name = selectedPlacemark.name
                address = selectedPlacemark.address
            }
        }
    }
    func fetchLookaroundPreview() async{
        if let destination = destinationCoordinate{
            lookaroundScene = nil
            let lookaroundRequest = MKLookAroundSceneRequest(coordinate: destination)
            lookaroundScene = try? await lookaroundRequest.scene
            
        }
    }
    
    
}
