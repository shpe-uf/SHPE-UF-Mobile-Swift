//
//  PointsViewModel.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by Jesus Lopez on 10/23/23.
//

import Foundation
import SwiftUI
import CoreData
// The View Model will focus on bridging user input through the View and the Model.

// The View Model will be the one to make the service calls and store data in the Model.

/// Manages all points-related functionality for the SHPEito application.
///
/// This ViewModel:
/// 1. Handles user points data (total and seasonal)
/// 2. Manages percentile rankings
/// 3. Processes event redemption and tracking
/// 4. Synchronizes data between network, Core Data, and UI
///
/// ## Key Features
/// - Published properties for SwiftUI binding
/// - Network request handling through `RequestHandler`
/// - Core Data integration for event persistence
/// - Comprehensive error handling
/// - Loading state management
///
/// ## Example Usage
/// ```swift
/// @StateObject var pointsVM = PointsViewModel(shpeito: shpeitoUser)
/// pointsVM.redeemCode(code: "ABC123", coreEvents: fetchedEvents, viewContext: context, dismiss: dismiss)
/// ```
final class PointsViewModel:ObservableObject {
    // Private variables like the Apollo endpoint
    private var requestHandler = RequestHandler()

    // Out of View variables (Models)
    @Published var shpeito: SHPEito
    
    // Initialize PointsViewModel
    init(shpeito: SHPEito) {
        self.shpeito = shpeito
        self.points = shpeito.points
        // Any other setup steps you need...
        self.fallPercentile = shpeito.fallPercentile
        self.springPercentile = shpeito.springPercentile
        self.summerPercentile = shpeito.summerPercentile
        self.fallPoints = shpeito.fallPoints
        self.springPoints = shpeito.springPoints
        self.summerPoints = shpeito.summerPoints
        self.username = shpeito.username
        self.id = shpeito.id
        self.categorizedEvents = [:]
    }
    
    // In View variables (What is being DISPLAYED & What is being INTERACTED WITH)
    @Published var addPointsClicked : Bool = false
    @Published var points : Int
    @Published var fallPercentile : Int
    @Published var springPercentile : Int
    @Published var summerPercentile : Int
    @Published var fallPoints : Int
    @Published var springPoints : Int
    @Published var summerPoints : Int
    @Published var username : String
    @Published var id : String
    @Published var categorizedEvents: [String: [UserEvent]]
    
    @Published var gettingPoints:Bool = false
    @Published var gettingEvents:Bool = false
    @Published var doAnimation:Bool = false
    @Published var invalidCode:Bool = false
    
    /// Fetches and updates the user's total points from the server.
    ///
    /// This function:
    /// 1. Makes a network request to retrieve the user's total points
    /// 2. Updates both the data model and display properties on success
    /// 3. Handles errors and data parsing failures appropriately
    ///
    /// ## Flow
    /// 1. Requests points data from server using the user's ID
    /// 2. On success:
    ///    - Updates model with total points
    ///    - Synchronizes display property with model value
    /// 3. On failure:
    ///    - Logs appropriate error messages
    ///
    /// ## Important
    /// - Updates UI-bound properties (must be called on main thread)
    /// - Maintains synchronization between model and display values
    /// - Validates both points and user ID in response
    ///
    /// ## Example
    /// ```swift
    /// setShpeitoPoints()
    /// ```
    func setShpeitoPoints()
    {
        requestHandler.fetchUserPoints(userId: shpeito.id) { data in
            // Check that no error was detected
            if data["error"] == nil
            {
                // Check if all the data is there and is the correct Type
                if let points = data["points"] as? Int,
                   let _ = data["userId"] as? String
                {
                    // Do something with the data
                    self.shpeito.points = points //Update the model
                    self.points = points // Update the information being displayed
                }
                else
                {
                    // Handle missing data error
                    print("Parsing error:\(data)")
                }
            }
            else
            {
                // Handle error response
                print(data["error"]!)
            }
        }
    }
    
    /// Fetches and updates seasonal percentile rankings for the current user.
    ///
    /// This function:
    /// 1. Makes a network request to retrieve the user's seasonal percentiles
    /// 2. Updates both the data model and display properties on success
    /// 3. Handles errors and data parsing failures appropriately
    /// 4. Manages loading state and triggers completion animation
    ///
    /// - Note: Percentiles represent the user's ranking compared to others (0-100)
    ///
    /// ## Flow
    /// 1. Initiates network request for percentile data
    /// 2. On success:
    ///    - Updates model with seasonal percentiles
    ///    - Synchronizes display properties
    ///    - Triggers completion animation
    /// 3. On failure:
    ///    - Logs appropriate error messages
    ///    - Still completes loading state and animation
    ///
    /// ## Important
    /// - Updates UI-bound properties (must be called on main thread)
    /// - Always completes by setting `gettingPoints` to false
    /// - Uses a 2-second ease-in animation for visual feedback
    ///
    /// ## Example
    /// ```swift
    /// setShpeitoPercentiles()
    /// ```
    func setShpeitoPercentiles()
    {
        requestHandler.getPercentiles(userId: self.id) { data in
            // Check that no error was detected
            if data["error"] == nil
            {
                // Check if all the data is there and is the correct Type
                if let fallPercentile = data["fallPercentile"] as? Int,
                   let springPercentile = data["springPercentile"] as? Int,
                   let summerPercentile = data["summerPercentile"] as? Int
                {
                    // Do something with the data
                    
                    self.shpeito.fallPercentile = fallPercentile //Update the model
                    self.shpeito.springPercentile = springPercentile
                    self.shpeito.summerPercentile = summerPercentile
                    
                    self.fallPercentile = fallPercentile // Update the information being displayed
                    self.springPercentile = springPercentile
                    self.summerPercentile = summerPercentile
                    
                }
                else
                {
                    // Handle missing data error
                    print("Parsing error: \(data)")
                }
            }
            else
            {
                // Handle error response
                print(data["error"]!)
            }
            
            withAnimation(.easeIn(duration: 2))
            {
                self.doAnimation = true
            }
            self.gettingPoints = false
        }
    }
    
    /// Fetches and updates seasonal points for the current user.
    ///
    /// This function:
    /// 1. Makes a network request to retrieve the user's seasonal points
    /// 2. Updates both the data model and display properties on success
    /// 3. Handles errors and data parsing failures appropriately
    ///
    /// ## Flow
    /// 1. Requests points data from server using the user's ID
    /// 2. On success:
    ///    - Updates model with fall, spring, and summer points
    ///    - Synchronizes display properties with model values
    /// 3. On failure:
    ///    - Logs appropriate error messages
    ///
    /// ## Important
    /// - Updates UI-bound properties (must be called on main thread)
    /// - Maintains synchronization between model and display values
    /// - Handles all error cases gracefully
    ///
    /// ## Example
    /// ```swift
    /// getShpeitoPoints()
    /// ```
    func getShpeitoPoints()
    {
        requestHandler.getPoints(userId: self.id) { data in
            // Check that no error was detected
            if data["error"] == nil
            {
                // Check if all the data is there and is the correct Type
                if let fallPoints = data["fallPoints"] as? Int,
                   let springPoints = data["springPoints"] as? Int,
                   let summerPoints = data["summerPoints"] as? Int
                {
                    // Do something with the data
                    self.shpeito.fallPoints = fallPoints //Update the model
                    self.shpeito.springPoints = springPoints
                    self.shpeito.summerPoints = summerPoints
                    
                    self.fallPoints = fallPoints // Update the information being displayed
                    self.springPoints = springPoints
                    self.summerPoints = summerPoints
                }
                else
                {
                    // Handle missing data error
                    print("Parsing error: \(data)")
                }
            }
            else
            {
                // Handle error response
                print(data["error"]!)
            }
        }
    }
    
    /// Redeems a points code and updates user data accordingly.
    ///
    /// This function:
    /// 1. Sends a redemption request to the server
    /// 2. Handles successful responses by updating all point values
    /// 3. Manages UI state and animations
    /// 4. Persists event data to Core Data
    /// 5. Handles errors and invalid codes gracefully
    ///
    /// - Parameters:
    ///   - code: The redemption code to process
    ///   - guests: Number of guests (defaults to 0)
    ///   - coreEvents: Fetched Core Data results for event persistence
    ///   - viewContext: Managed object context for Core Data operations
    ///   - dismiss: SwiftUI dismiss action for sheet management
    ///
    /// ## Flow
    /// 1. Makes network request via `requestHandler`
    /// 2. On success:
    ///    - Updates all point values (seasonal and total)
    ///    - Updates percentiles if available
    ///    - Processes and stores event data
    ///    - Triggers success animation
    /// 3. On failure:
    ///    - Sets error states
    ///    - Triggers error animation
    ///
    /// ## Important
    /// - Updates multiple `@Published` properties (must be called on main thread)
    /// - Manages complex state including animations
    /// - Handles both points and event data updates
    ///
    /// ## Example
    /// ```swift
    /// redeemCode(
    ///     code: "ABCD123",
    ///     guests: 2,
    ///     coreEvents: fetchedEvents,
    ///     viewContext: container.viewContext,
    ///     dismiss: dismiss
    /// )
    /// ```
    func redeemCode(code: String, guests: Int = 0, coreEvents: FetchedResults<CoreUserEvent>, viewContext: NSManagedObjectContext, dismiss: DismissAction)
    {
        requestHandler.redeemPoints(code: code, username: shpeito.username, guests: guests)
        { data in
            // Check that no error was detected
            if data["error"] == nil
            {
                // Check if all the data is there and is the correct Type
                if let fallPoints = data["fallPoints"] as? Int,
                   let springPoints = data["springPoints"] as? Int,
                   let summerPoints = data["summerPoints"] as? Int
                {
                    self.doAnimation = false
                    self.invalidCode = false
                    // Do something with the data
                    self.shpeito.fallPoints = fallPoints //Update the model
                    self.shpeito.springPoints = springPoints
                    self.shpeito.summerPoints = summerPoints
                    self.shpeito.points = data["points"] as? Int ?? fallPoints + springPoints + summerPoints
                    
                    self.fallPoints = fallPoints // Update the information being displayed
                    self.springPoints = springPoints
                    self.summerPoints = summerPoints
                    self.points = data["points"] as? Int ?? fallPoints + springPoints + summerPoints
                    
                    
                    if let fallPercentile = data["fallPercentile"] as? Int,
                       let springPercentile = data["springPercentile"] as? Int,
                       let summerPercentile = data["summerPercentile"] as? Int
                    {
                        self.shpeito.fallPercentile = fallPercentile
                        self.shpeito.springPercentile = springPercentile
                        self.shpeito.summerPercentile = summerPercentile
                        
                        self.fallPercentile = fallPercentile
                        self.springPercentile = springPercentile
                        self.summerPercentile = summerPercentile
                    }
                    
                    if let _ = data["events"] as? [UserEvent],
                       let eventbyCategory = data["eventsByCategory"] as? [String: [UserEvent]]
                    {
                        self.gettingEvents = false
                        self.categorizedEvents = eventbyCategory
                        for events in eventbyCategory.values
                        {
                            CoreFunctions().saveRedeemedEvents(events: coreEvents, viewContext: viewContext, userEvents: events)
                        }
                    }
                    
                    dismiss()
                }
                else
                {
                    // Handle missing data error
                    print("Incorrect data")
                    self.invalidCode = true
                }
            }
            else
            {
                // Handle error response
                print(data["error"]!)
                self.invalidCode = true
            }
            
            withAnimation(.easeIn(duration: 2))
            {
                self.doAnimation = true
            }
        }
    }
    
    /// Fetches and processes user events from both network and Core Data.
    ///
    /// This function:
    /// 1. Makes a network request to fetch user events
    /// 2. Handles successful responses by updating local state and Core Data
    /// 3. Falls back to Core Data when network requests fail
    /// 4. Manages the `gettingEvents` state flag
    ///
    /// - Parameters:
    ///   - coreEvents: Fetched Core Data results to use as fallback
    ///   - viewContext: Managed object context for Core Data operations
    ///
    /// ## Flow
    /// 1. Attempt network request via `requestHandler`
    /// 2. On success:
    ///    - Update `categorizedEvents` with network data
    ///    - Persist events to Core Data
    /// 3. On failure:
    ///    - Fall back to Core Data events
    ///    - Log appropriate errors
    ///
    /// ## Important
    /// - Updates UI via `@Published` properties (must be called on main thread)
    /// - Maintains synchronization between network and local data
    /// - Handles all error cases gracefully
    ///
    /// ## Example
    /// ```swift
    /// getUserEvents(
    ///     coreEvents: fetchedEvents,
    ///     viewContext: container.viewContext
    /// )
    /// ```
    func getUserEvents(coreEvents: FetchedResults<CoreUserEvent>, viewContext: NSManagedObjectContext)
    {
        requestHandler.getUserEvents(userId: self.id) { data in
            // Check that no error was detected
            if data["error"] == nil
            {
                // Check if all the data is there and is the correct Type
                if let _ = data["events"] as? [UserEvent],
                   let eventbyCategory = data["eventsByCategory"] as? [String: [UserEvent]]
                {
                    self.gettingEvents = false
                    self.categorizedEvents = eventbyCategory
                    for events in eventbyCategory.values
                    {
                        CoreFunctions().saveRedeemedEvents(events: coreEvents, viewContext: viewContext, userEvents: events)
                    }
                }
                else
                {
                    // Handle missing data error
                    self.categorizedEvents=self.setEventsFromCore(coreEvents: coreEvents)
                    print("Parsing error: \(data)")
                }
            }
            else
            {
                // Handle error response
                self.categorizedEvents=self.setEventsFromCore(coreEvents: coreEvents)
                print(data["error"]!)
            }
        }
    }
    
    /// Converts Core Data entities into categorized UserEvent dictionaries.
    ///
    /// This function:
    /// 1. Filters valid events from Core Data results
    /// 2. Organizes events into a dictionary by category
    /// 3. Prints debug information for invalid/malformed events
    ///
    /// - Parameter coreEvents: Fetched Core Data results of type `CoreUserEvent`
    /// - Returns: Dictionary mapping categories to arrays of valid `UserEvent` objects
    ///
    /// ## Important
    /// - Skips events with missing required fields (prints debug info)
    /// - Returns empty dictionary if no valid events found
    /// - Maintains original event ordering within each category
    ///
    /// ## Example
    /// ```swift
    /// let eventsByCategory = setEventsFromCore(coreEvents: fetchedEvents)
    /// let workshopEvents = eventsByCategory["Workshop"] ?? []
    /// ```
    private func setEventsFromCore(coreEvents: FetchedResults<CoreUserEvent>) -> [String: [UserEvent]]
    {
        let userEvents = {
            var validEvents:[UserEvent] = []
            for event in coreEvents
            {
                print(event.identifier as Any, event.name as Any, event.category as Any, event.points as Any, event.createdAt as Any)
                if let id = event.identifier,
                   let name = event.name,
                   let category = event.category,
                   let date = event.createdAt
                {
                    validEvents.append(UserEvent(id: id, name: name, category: category, points: Int(event.points), date: date))
                }
            }
            return validEvents
        }()
        
        var eventsByCategory:[String:[UserEvent]] = [:]
        
        for event in userEvents {
            if (eventsByCategory[event.category] != nil)
            {
                eventsByCategory[event.category]!.append(event)
            }
            else
            {
                eventsByCategory[event.category] = [event]
            }
        }
        
        return eventsByCategory
    }
    
    
}
