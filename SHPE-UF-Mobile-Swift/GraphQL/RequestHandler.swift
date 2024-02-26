//
//  Apollo.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by Daniel Parra on 1/17/24.
//

import Foundation
import Apollo

class RequestHandler
{
    let apolloClient = ApolloClient(url: URL(string: "https://b851-128-227-1-26.ngrok-free.app")!) // MUST BE NGROK URL or http://127.0.0.1:5000/
    
    // MARK: Example Query Function
    // This is how the functions I will make for you guys will look like
    func fetchUserPoints(userId:String, completion: @escaping ([String:Any])->Void)
    {
        // Function was successfully called
        print("Fetching User Points")
        do
        {
            // Validate inputs
            let validId = try SHPESchema.ID(_jsonValue: JSONValue(userId))
            
            // Make Apollo Client Call
            apolloClient.fetch(query: SHPESchema.GetUserPointsQuery(userId: validId))
            {
                response in
                
                // Process Server Response
                guard let data = try? response.get().data else
                {
                    print("ERROR: Incomplete Request\nError Message:\(response)")
                    
                    // Package with data (ERROR ❌)
                    completion(["error":"Incomplete Request"])
                    return
                }
                
                // Package with data (SUCCESS ✅)
                let responseDict = [
                    "userId":userId,
                    "points": data.getUser?.points ?? -1
                ]
                completion(responseDict)
            }
        }
        catch
        {
            print("Invalid Id")
            // Package with data (ERROR ❌)
            completion(["error":"Invalid ID"])
        }
    }
    
    // MARK: Register/SignIn Page Functions
    
    // RegisterUserMutation <= RegisterUser.graphql
    // Input: firstName: String, lastName: String, major: String, year: String, graduating: String, country: String, ethnicity: String, sex: String, username: String, email: String, password: String, confirmPassword: String, listServ: String = "true"
    // Succesful Output: ["success":Bool] => Only returns true
    func registerUser(firstName: String, lastName: String, major: String, year: String, graduating: String, country: String, ethnicity: String, sex: String, username: String, email: String, password: String, confirmPassword: String, listServ: String = "true", completion: @escaping ([String:Any])->Void)
    {
        let registerInput = SHPESchema.RegisterInput(firstName: firstName, lastName: lastName, major: major, year: year, graduating: graduating, country: country, ethnicity: ethnicity, sex: sex, username: username, email: email, password: password, confirmPassword: confirmPassword, listServ: listServ)
        
        let validInput = GraphQLNullable(registerInput)
        
        apolloClient.perform(mutation: SHPESchema.RegisterUserMutation(registerInput: validInput))
        {
            response in
            
            guard let data = try? response.get().data
            else {
                print("ERROR: Incomplete Request\nError Message:\(response)")
                
                // Package with data (ERROR ❌)
                completion(["error":"Incomplete Request"])
                return
            }
            
            let responseDict = [
                "success": true
            ]
            
            completion(responseDict)
        }
    }
    
    // SignInMutation <= SignIn.graphql
    // Input: username: String, password: String
    // Successful Output: [
    //    "firstName": String,
    //    "lastName": String,
    //    "year": String,
    //    "major": String,
    //    "id": String,
    //    "token": String,
    //    "confirmed": Bool,
    //    "updatedAt": String,
    //    "createdAt": String,
    //    "email": String,
    //    "username": String,
    //    "fallPoints": Int,
    //    "springPoints": Int,
    //    "summerPoints": Int,
    //    "photo": String, => You may want to turn this into a Swift URL type by doing this => URL(string: <photo>)
    //    "events": [SHPESchema.SignInMutation...Event]
    //]
    func signIn(username:String, password:String, completion: @escaping ([String:Any])->Void)
    {
        apolloClient.perform(mutation: SHPESchema.SignInMutation(username: username, password: password, remember: "false"))
        {
            response in
            guard let data = try? response.get().data
            else
            {
                print("ERROR: Incomplete Request\nError Message:\(response)")
                
                // Package with data (ERROR ❌)
                completion(["error":"Incomplete Request"])
                return
            }
            // Package with data (SUCCESS ✅)
            let login = data.login
            let responseDict = [
                "firstName": login.firstName,
                "lastName": login.lastName,
                "year": login.year,
                "major": login.major,
                "id": login.id,
                "token": login.token,
                "confirmed": login.confirmed,
                "updatedAt": login.updatedAt,
                "createdAt": login.createdAt,
                "email": login.email,
                "username": login.username,
                "fallPoints": login.fallPoints,
                "springPoints": login.springPoints,
                "summerPoints": login.summerPoints,
                "photo": login.photo,
                "events": login.events
            ]
            
            completion(responseDict)
        }
    }
    
    // MARK: Points Page Funcations
    
    // RedeemPointsMutation <= RedeemPoints.graphql
    // Input: code: String, username: String, guests: Int (Number of guests)
    // Successful Output: "fallPoints": Int,
    //                    "springPoints": Int,
    //                    "summerPoints": Int
    func redeemPoints(code: String, username: String, guests:Int, completion: @escaping ([String:Any])->Void)
    {
        let redeemPointsinput = SHPESchema.RedeemPointsInput(code: code, username: username, guests: guests)
        
        let validInput = GraphQLNullable(redeemPointsinput)
        
        apolloClient.perform(mutation: SHPESchema.RedeemPointsMutation(redeemPointsInput: validInput))
        {
            response in
            
            // Process Server Response
            guard let data = try? response.get().data
            else
            {
                print("ERROR: Incomplete Request\nError Message:\(response)")
                
                // Package with data (ERROR ❌)
                completion(["error":"Incomplete Request"])
                return
            }
            
            // Package with data (SUCCESS ✅)
            let responseDict = [
                "fallPoints": data.redeemPoints.fallPoints,
                "springPoints": data.redeemPoints.springPoints,
                "summerPoints": data.redeemPoints.summerPoints
            ]
            
            completion(responseDict)
        }
    }
    
    // GetPercentilesQuery <= GetPercentiles.graphql
    // Input: userId: String
    // Successful Output: ["fallPercentile": Int, "springPercentile": Int, "summerPercentile": Int]
    func getPercentiles(userId: String, completion: @escaping ([String:Any])->Void)
    {
        apolloClient.fetch(query: SHPESchema.GetPercentilesQuery(userId: userId))
        {
            response in
            
            guard let data = try? response.get().data,
                  let fallPercentile = data.getUser?.fallPercentile as? Int,
                  let springPercentile = data.getUser?.springPercentile as? Int,
                  let summerPercentile = data.getUser?.summerPercentile as? Int
            else
            {
                print("ERROR: Incomplete Request\nError Message:\(response)")
                
                // Package with data (ERROR ❌)
                completion(["error":"Incomplete Request"])
                return
            }
            
            // Package with data (SUCCESS ✅)
            let responseDict = [
                "fallPercentile": fallPercentile,
                "springPercentile": springPercentile,
                "summerPercentile": summerPercentile
            ]
            
            completion(responseDict)
        }
    }
    
    // MARK: Home Page Functions
    // Input: minDate: Date Captures any events after minDate
    // Successful Output: ([Event],Bool,String) => List of Event objects, boolean value True:Success, False:Error, String describing error
    //                                                                                                (FATAL_ERROR, REQUEST_ERROR, PARSE_ERROR)
    func fetchEvents(minDate: Date, completion:@escaping (([Event], Bool, String))->Void = {_ in})
    {
        let dateFormatter = ISO8601DateFormatter()
        let timeMin = dateFormatter.string(from: minDate)
        
        // Get evnironment variables
        guard let CALENDAR_ID = ProcessInfo.processInfo.environment["CALENDAR_ID"] else
        {
            print("CALENDAR_ID is missing from environment variables")
            completion(([],false,"FATAL_ERROR"))
            return
        }
        guard let CALENDAR_API_KEY = ProcessInfo.processInfo.environment["CALENDAR_API_KEY"] else
        {
            print("CALENDAR_API_KEY is missing from environment variables")
            completion(([],false,"FATAL_ERROR"))
            return
        }

        // Make an API call
        let urlString = "https://www.googleapis.com/calendar/v3/calendars/\(CALENDAR_ID)/events?timeMin=\(timeMin)&key=\(CALENDAR_API_KEY)"
        if let url = URL(string: urlString) {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if error != nil
                {
                    print("Error: \(error!.localizedDescription)")
                    completion(([],false,"REQUEST_ERROR"))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("Invalid response")
                    completion(([],false,"REQUEST_ERROR"))
                    return
                }

                if !(200...299).contains(httpResponse.statusCode) {
                    print("HTTP Error: \(httpResponse.statusCode)")
                    completion(([],false,"REQUEST_ERROR"))
                    return
                }
                
                if let data = data
                {
                    do {
                        if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] 
                        {
                            var eventsList:[Event] = []
                            print("ITEMS:")
                            if let items = jsonObject["items"] as? (any Sequence)
                            {
                                for item in items
                                {
                                    guard let object = item as? [String:Any] else
                                    {
                                        print("Unexpected data type")
                                        completion(([],false,"PARSE_ERROR"))
                                        return
                                    }

                                    do {
                                        let event = try self.extractEvent(from: object)
                                        eventsList.append(event)
                                    } catch {
                                        print("Error extracting event: \(error)")
                                        print("\nOBJECT WITH ERROR:")
                                        print(object)
                                        print()
                                        continue
                                    }
                                }
                                
                                // SUCCESS ✅
                                completion((eventsList,true,""))
                            }
                            else
                            {
                                completion(([],false,"PARSE_ERROR"))
                                print("ERROR: 'items' field missing in JSON")
                            }
                        } else {
                            completion(([],false,"PARSE_ERROR"))
                            print("Failed to convert JSON data to dictionary")
                        }
                    } catch {
                        print("Error decoding JSON: \(error.localizedDescription)")
                        completion(([],false,"PARSE_ERROR"))
                    }
                }
            }
            task.resume()
        }
    }
    
    private func extractEvent(from dictionary: [String: Any]) throws -> Event {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

        guard
            let createdString = dictionary["created"] as? String,
            let created = dateFormatter.date(from: createdString),
            let creatorDict = dictionary["creator"] as? [String: Any],
            let creator = try? extractCreator(from: creatorDict),
            let endDict = dictionary["end"] as? [String: Any],
            let etag = dictionary["etag"] as? String,
            let eventType = dictionary["eventType"] as? String,
            let htmlLink = dictionary["htmlLink"] as? String,
            let iCalUID = dictionary["iCalUID"] as? String,
            let id = dictionary["id"] as? String,
            let organizerDict = dictionary["organizer"] as? [String: Any],
            let organizer = try? extractOrganizer(from: organizerDict),
            let sequence = dictionary["sequence"] as? Int,
            let startDict = dictionary["start"] as? [String: Any],
            let status = dictionary["status"] as? String,
            let summary = dictionary["summary"] as? String,
            let updatedString = dictionary["updated"] as? String,
            let updated = dateFormatter.date(from: updatedString)
        else {
            throw NSError(domain: "ParsingError", code: 1, userInfo: nil)
        }
        
        let kind = dictionary["kind"] as? String ?? nil
        let end = ((try? extractEventDateTime(from: endDict)) ?? (try? extractCustomDateTime(from: endDict))) ?? EventDateTime(dateTime: Date(), timeZone: "ERROR")
        let start = ((try? extractEventDateTime(from: startDict)) ?? (try? extractCustomDateTime(from: startDict))) ?? EventDateTime(dateTime: Date(), timeZone: "ERROR")
        
        // Optional Fields
        let location = dictionary["location"] as? String ?? nil

        let event = Event(
            created: created,
            creator: creator,
            end: end,
            etag: etag,
            eventType: eventType,
            htmlLink: htmlLink,
            iCalUID: iCalUID,
            id: id,
            kind: kind,
            organizer: organizer,
            sequence: sequence,
            start: start,
            status: status,
            summary: summary,
            updated: updated,
            location: location
        )
        
        return event
    }

    // Helper functions to extract nested objects
    private func extractCreator(from dictionary: [String: Any]) throws -> Creator {
        guard
            let email = dictionary["email"] as? String,
            let selfValue = dictionary["self"] as? Int
        else {
            throw NSError(domain: "ParsingError", code: 1, userInfo: nil)
        }

        return Creator(email: email, selfValue: selfValue)
    }

    private func extractEventDateTime(from dictionary: [String: Any]) throws -> EventDateTime {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"

        guard
            let dateTimeString = dictionary["dateTime"] as? String,
            let dateTime = dateFormatter.date(from: dateTimeString),
            let timeZone = dictionary["timeZone"] as? String
        else {
            throw NSError(domain: "ParsingError", code: 1, userInfo: nil)
        }

        return EventDateTime(dateTime: dateTime, timeZone: timeZone)
    }
    
    private func extractCustomDateTime(from dictionary:[String:Any]) throws -> EventDateTime
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        guard
            let dateTimeString = dictionary["date"] as? String,
            let dateTime = dateFormatter.date(from: dateTimeString)
        else {
            throw NSError(domain: "ParsingError", code: 1, userInfo: nil)
        }
        
        return EventDateTime(dateTime: dateTime, timeZone: "")
    }

    private func extractOrganizer(from dictionary: [String: Any]) throws -> Organizer {
        guard
            let email = dictionary["email"] as? String,
            let selfValue = dictionary["self"] as? Int
        else {
            throw NSError(domain: "ParsingError", code: 1, userInfo: nil)
        }

        return Organizer(email: email, selfValue: selfValue)
    }
}

