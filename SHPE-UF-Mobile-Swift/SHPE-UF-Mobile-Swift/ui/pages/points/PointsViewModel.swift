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
    
    // Methods to call in View
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
                    print("Success!")
                    // Do something with the data
                    self.shpeito.points = points //Update the model
                    self.points = points // Update the information being displayed
                }
                else
                {
                    // Handle missing data error
                    print("Incorrect data")
                }
            }
            else
            {
                // Handle error response
                print(data["error"]!)
            }
        }
    }
    
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
                    print("Success!")
                    print(data)
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
                    print("Incorrect data")
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
                    print("Success!")
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
                    print("Incorrect data")
                }
            }
            else
            {
                // Handle error response
                print(data["error"]!)
            }
        }
    }
    
    func redeemCode(code: String, guests: Int = 0, coreEvents: FetchedResults<CoreUserEvent>, viewContext: NSManagedObjectContext, dismiss: DismissAction)
    {
        
        print("HERE")
        
        requestHandler.redeemPoints(code: code, username: shpeito.username, guests: guests)
        { data in
            
            print(self.username)
            print(data)
            
            
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
                    
                    self.fallPoints = fallPoints // Update the information being displayed
                    self.springPoints = springPoints
                    self.summerPoints = summerPoints
                    
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
                    
                    if let event = data["events"] as? [UserEvent],
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
        }
    }
    
    func getUserEvents(coreEvents: FetchedResults<CoreUserEvent>, viewContext: NSManagedObjectContext)
    {
        requestHandler.getUserEvents(userId: self.id) { data in
            // Check that no error was detected
            if data["error"] == nil
            {
                // Check if all the data is there and is the correct Type
                if let event = data["events"] as? [UserEvent],
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
                    print("Incorrect data")
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
