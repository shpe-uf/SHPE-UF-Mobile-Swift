//
//  HomeViewModel.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by Jesus Lopez on 10/23/23.
//

import Foundation

final class HomeViewModel: ObservableObject {
    private var requestHandler = RequestHandler()
    
    @Published var events: [Event] = []
    
    init() {
        fetchEvents()
    }
    
    func fetchEvents(){
        // Set the minimum date for events to be fetched (e.g., today's date)
        let minDate = Date()
        
        // Call the fetchEvents method from the RequestHandler
        requestHandler.fetchEvents(minDate: minDate) { [weak self] (events, success, error) in
            DispatchQueue.main.async {
                if success {
                    // Sort the events by their start dates
                    let sortedEvents = events.sorted(by: { $0.start.dateTime < $1.start.dateTime })
                    // Update the events property with the sorted events
                    self?.events = sortedEvents
                    self?.updateEventTypes()
                } else {
                    // Handle error condition
                    print("Error fetching events: \(error)")
                }
            }
        }
    }
    
    private func updateEventTypes() {
            for index in 0..<events.count {
                let event = events[index]
                
                // Changes event types based on keywords in title of event
                
                if event.summary.contains("GBM") {
                    events[index].eventType = "GBM"
                } else if event.summary.contains("Bootcamp") || event.summary.contains("Workshop") || event.summary.contains("Tank"){
                    events[index].eventType = "Workshop"
                } else if event.summary.contains("Social") || event.summary.contains("Fundraiser") {
                    events[index].eventType = "Social"
                } else if event.summary.contains("volunteering") {
                    events[index].eventType = "Volunteering"
                }else if event.summary.contains("Info") {
                    events[index].eventType = "Info"
                }else{
                    events[index].eventType = "Social"
                }
                
            }
    }
}
