//
//  PointsViewModel.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by Jesus Lopez on 10/23/23.
//

import Foundation

// The View Model will focus on bridging user input through the View and the Model.

// The View Model will be the one to make the service calls and store data in the Model.

final class PointsViewModel:ObservableObject {
    // Private variables like the Apollo endpoint
    private var requestHandler = RequestHandler()

    // Out of View variables (Models)
    @Published var shpeito:SHPEito
    
    // Initialize PointsViewModel
    init(shpeito: SHPEito) {
        self.shpeito = shpeito
        self.points = shpeito.points
        // Any other setup steps you need...
    }
    
    // In View variables (What is being DISPLAYED & What is being INTERACTED WITH)
    @Published var addPointsClicked:Bool = false
    @Published var points:Int
    
    // Methods to call in View
    func setShpeitoPoints()
    { 
        requestHandler.fetchUserPoints(userId: shpeito.id) { data in
            // Check that no error was detected
            if data["error"] == nil
            {
                // Check if all the data is there and is the correct Type
                if let points = data["points"] as? Int,
                   let userId = data["userId"] as? String
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
    
    func add5PointsToShpeito()
    {
        // This would be done after we call the mutation to add 5 points to our shpeito
        self.shpeito.points += 5
        self.points += 5
    }
    
    func resetShpeitoPoints()
    {
        self.shpeito.points = 0
        self.points = 0
    }
    
    // DELETE ME RIGHT AFTER
    func printEvents()
    {
        let oneYearAgo = Date(timeIntervalSinceNow: -10 * 24 * 60 * 60)
        requestHandler.fetchEvents(minDate: oneYearAgo)
    }
}
