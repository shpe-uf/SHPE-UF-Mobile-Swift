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
    
    func fetchEvents() {
        // Set the minimum date for events to be fetched (e.g., today's date)
        let minDate = Date()
        
        // Call the fetchEvents method from the RequestHandler
        requestHandler.fetchEvents(minDate: minDate) { [weak self] (events, success, error) in
            DispatchQueue.main.async {
                if success {
                    // Update the events property with the fetched events
                    self?.events = events
                } else {
                    // Handle error condition
                    print("Error fetching events: \(error)")
                }
            }
        }
    }
}
