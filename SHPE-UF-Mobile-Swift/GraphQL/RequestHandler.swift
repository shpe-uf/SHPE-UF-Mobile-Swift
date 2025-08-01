//
//  Apollo.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by Daniel Parra on 1/17/24.
//


import Foundation
import Apollo

private let DEVELOPMENT = false

private let PRODUCTION_ENV =
[
    "SERVER_LINK":"",
    "CALENDAR_ID":"",
    "CALENDAR_API_KEY":""
]

private let ACCESS = DEVELOPMENT ? ProcessInfo.processInfo.environment : PRODUCTION_ENV


/// A network request handler for SHPE UF Mobile application
///
/// Handles all API communications including:
/// - User authentication (registration, login)
/// - Points management and redemption
/// - Profile management
/// - Event fetching
///
/// Uses Apollo Client for GraphQL operations and URLSession for REST API calls.
///
/// ## Important Environment Variables
/// - `SERVER_LINK`: Backend server URL (GraphQL endpoint)
/// - `CALENDAR_ID`: Google Calendar ID for events
/// - `CALENDAR_API_KEY`: API key for calendar access
///
/// ## Error Handling
/// All methods use completion handlers that return dictionaries which may contain:
/// - Success data (structure varies by endpoint)
/// - `["error": String]` for failures
/// - `["success": Bool]` for simple operations
class RequestHandler
{
    let apolloClient = ApolloClient(url: URL(string:  ACCESS["SERVER_LINK"]!)!) // MUST BE NGROK URL or //http://127.0.0.1:5000/
//    let apolloClient = ApolloClient(url: URL(string: "")!) // MUST BE NGROK URL or //http://127.0.0.1:5000/
    //ProcessInfo.processInfo.environment["SERVER_LINK"]!
    // MARK: Example Query Function
    // This is how the functions I will make for you guys will look like
    func fetchUserPoints(userId:String, completion: @escaping ([String:Any])->Void)
    {
        // Function was successfully called
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
            // Package with data (ERROR ❌)
            completion(["error":"Invalid ID"])
        }
    }
    
    func fetchPartners(completion: @escaping ([SHPESchema.GetPartnersQuery.Data.GetPartner]) -> Void)
    {
        apolloClient.fetch(query: SHPESchema.GetPartnersQuery(),
                           cachePolicy: .fetchIgnoringCacheData) { result in
          switch result {
          case .success(let graphQLResult):
            // compactMap to drop any nils
            let partners = graphQLResult
              .data?
              .getPartners?
              .compactMap { $0 }
              ?? []
            completion(partners)

          case .failure(let error):
            print("❌ Error fetching partners:", error)
            completion([])
          }
        }
    }
    
    
    //MARK: Register/SignIn Page Functions
    
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
            
            guard let _ = try? response.get().data
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
    
    
    /*
     Input:
        username:String
        email:String
     Output:
        ["usernameExists":Bool,
         "emailExists":Bool]
     */
    func validateUsernameAndEmail(username:String, email:String, completion: @escaping ([String:Any])->Void)
    {
        apolloClient.fetch(query: SHPESchema.GetUsersQuery())
        {
            response in
            
            guard let data = try? response.get().data
            else {
                print("ERROR: Incomplete Request\nError Message:\(response)")
                
                // Package with data (ERROR ❌)
                completion(["error":"Incomplete Request"])
                return
            }
            
            var outputDict = [
                "usernameExists":false,
                "emailExists":false
            ]
            for user in data.getUsers ?? []
            {
                outputDict["usernameExists"] = outputDict["usernameExists"]! ? true : user?.username == username
                outputDict["emailExists"] = outputDict["emailExists"]! ? true : user?.email == email
                
                if outputDict["usernameExists"]! && outputDict["emailExists"]! {break}
            }
            
            completion(outputDict)
            return
        }
    }
    
    func validateEmail(email:String, completion: @escaping ([String:Any])->Void)
    {
        apolloClient.fetch(query: SHPESchema.GetUsersQuery()) { response in
            guard let data = try? response.get().data else {
                print("ERROR: Incomplete Request\nError Message:\(response)")
 
                if let errors = try? response.get().errors {
                    let errorMessage = errors.map { $0.localizedDescription }.joined(separator: ", ")
                    completion(["error": errorMessage])
                } else {
                    completion(["error": "Incomplete Request"])
                }
                return
            }
 
            var outputDict = [
                "emailExists": false
            ]
 
            for user in data.getUsers ?? [] {
                if let userEmail = user?.email, userEmail == email {
                    outputDict["emailExists"] = true
                    break
                }
            }
 
            completion(outputDict)
        }
    }
    func usersName(email: String, completion: @escaping ([String: Any]) -> Void) {
        apolloClient.fetch(query: SHPESchema.GetUsersQuery()) { response in
            guard let data = try? response.get().data else {
                print("ERROR: Incomplete Request\nError Message: \(response)")
                completion(["error": "Incomplete Request"])
                return
            }
            for user in data.getUsers ?? [] {
                if let userEmail = user?.email, userEmail == email {
                    // Return the user's username (or firstName, etc. — customize as needed)
                    completion(["name": user?.username ?? ""])
                    return
                }
            }
            completion(["error": "User not found"])
        }
    }
    
    func forgotPassword(email: String, completion: @escaping ([String: Any]) -> Void) {
            // Create the mutation with the email parameter
            apolloClient.perform(mutation: SHPESchema.ForgotPasswordMutation(email: email)) { response in
                // Process Server Response
                guard let data = try? response.get().data else {
                    print("ERROR: Incomplete Request\nError Message:(response)")

                    // Extract error message if available
                    if let errors = try? response.get().errors {
                        let errorMessage = errors.map { $0.localizedDescription }.joined(separator: ", ")
                        completion(["error": errorMessage])
                    } else {
                        // Generic error if we can't extract a specific message
                        completion(["error": "Incomplete Request"])
                    }
                    return
                }

                // Package with data (SUCCESS ✅)
                let responseDict = [
                    "message": data.forgotPassword.id,
                    "token": data.forgotPassword.token
                ]

                completion(responseDict)
            }
        }
    
//    func ComposeForgetEmail(recipient:String, name: String, completion: @escaping ([String:Any])->Void)
//    {// Composes an email to the users email for forgotten password
//        guard let url = URL(string: "https://your-email-service.com/send") else {
//                completion(["error": "Invalid URL"])
//                return
//            }
//            var request = URLRequest(url: url)
//            request.httpMethod = "POST"
//            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        let htmlBody = """
//        <!DOCTYPE html>
//        <html>
//          <head>
//            <meta charset="utf-8" />
//            <title>Password Reset</title>
//          </head>
//          <body style="margin:0; padding:0; background-color:#1f1f1f; color:#ffffff; font-family:Arial, sans-serif;">
//            <table width="100%" border="0" cellspacing="0" cellpadding="0" style="max-width:600px; margin:auto;">
//              <tr>
//                <td style="padding:20px;">
//                  <h1 style="color:#f2f2f2;">Hi, \(name)!</h1>
//                  <p style="color:#cccccc;">
//                    You have requested to reset the password for your account at <strong>shpeuf.com</strong>.
//                    <br /><br />
//                    Click below to reset your password:
//                  </p>
//                  <p style="text-align:center; margin:20px 0;">
//                    <a 
//                      href="" 
//                      style="background-color:#8b4b06; color:#ffffff; text-decoration:none; padding:15px 25px; border-radius:4px;"
//                    >
//                      Reset Password
//                    </a>
//                  </p>
//                  <p style="color:#cccccc;">
//                    NOTE! This link is active for one hour.
//                    <br /><br />
//                    If you haven’t requested a password reset, safely ignore this email.
//                  </p>
//                </td>
//              </tr>
//            </table>
//          </body>
//        </html>
//        """
//        let requestData: [String: Any] = [
//               "from": "https://www.shpeuf.com/forgot",
//               "to": recipient,
//               "subject": "Password Reset Request",
//               "html": htmlBody
//           ]
//
//           // 4. Convert to JSON
//           do {
//               request.httpBody = try JSONSerialization.data(withJSONObject: requestData, options: [])
//           } catch {
//               completion(["error": "Failed to encode JSON"])
//               return
//           }
//           
//           // 5. Send the request
//           URLSession.shared.dataTask(with: request) { data, response, error in
//               // Handle the response
//               guard let data = data, error == nil else {
//                   completion(["error": error?.localizedDescription ?? "Unknown error"])
//                   return
//               }
//               
//               // Optionally parse the response
//               if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
//                   completion(json)
//               } else {
//                   completion(["error":"Failed to parse response"])
//               }
//           }.resume()
//       }
    
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
    //    "ethnicity": String,
    //    "gender": String,
    //    "originCountry": String
    //    "graduationYear": String
    //    "classes": [String]
    //    "internships": [String]
    //    "links": [String]
    //    "photo": String, => You may want to turn this into a Swift URL type by doing this => URL(string: <photo>)
    //    "events": [SHPESchema.SignInMutation...Event]
    //]
    
    
    
    func signIn(username: String, password: String, completion: @escaping ([String: Any]) -> Void) {
        apolloClient.perform(mutation: SHPESchema.SignInMutation(username: username, password: password, remember: "false"), publishResultToStore: false) { response in
            guard let data = try? response.get().data else {
                if let errorMessage = self.extractErrorMessage(from: response) {
                    // Print the extracted error message
                    print("ERROR: \(errorMessage)\nError Message: \(response)")
                    
                    // Package with data (ERROR ❌)
                    completion(["error": errorMessage])
                } else {
                    print("ERROR: Incomplete Request\nError Message: \(response)")
                    
                    // Package with data (ERROR ❌)
                    completion(["error": "Incomplete Request"])
                }
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
                "photo": login.photo,
                "events": login.events,
                "ethnicity": login.ethnicity,
                "gender": login.sex,
                "originCountry": login.country,
                "graduationYear": login.graduating,
                "classes": login.classes ?? [],
                "internships": login.internships ?? [],
                "links": login.socialMedia ?? [],
                "permission": login.permission
            ]
            
            completion(responseDict)
        }
    }
    
    private func extractErrorMessage(from response: Result<Apollo.GraphQLResult<SHPE_UF_Mobile_Swift.SHPESchema.SignInMutation.Data>, Error>) -> String? {
        do {
            let graphqlResponse = try response.get()
            if let errors = graphqlResponse.errors {
                // Extract the error message from GraphQL errors
                let errorMessage = errors.map { $0.localizedDescription }.joined(separator: ", ")
                return errorMessage
            } else {
                return nil // No error message extracted
            }
        } catch {
            return error.localizedDescription
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
            var responseDict:[String:Any] = [
                "fallPoints": data.redeemPoints.fallPoints,
                "fallPercentile":data.redeemPoints.fallPercentile,
                "springPoints": data.redeemPoints.springPoints,
                "springPercentile": data.redeemPoints.springPercentile,
                "summerPoints": data.redeemPoints.summerPoints,
                "summerPercentile": data.redeemPoints.summerPercentile,
                "points": data.redeemPoints.points
            ]
            
            let events = data.redeemPoints.events.map({ event in
                  let formatter = DateFormatter()
                  formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'" // Match the date format exactly to the string
                  formatter.timeZone = TimeZone(secondsFromGMT: 0) // Set timezone to UTC
                  if let eventName = event?.name,
                      let category = event?.category,
                      let points = event?.points,
                      let dateString = event?.createdAt,
                      let date = formatter.date(from: dateString),
                      let id = event?.id
                  {
                      return UserEvent(id: id, name: eventName, category: category, points: Int(points), date: date)
                  }
                  else
                  {
                      return UserEvent(id: "", name: "none", category: "", points: -1, date: Date(timeIntervalSince1970: 0))
                  }
              })
            
            var eventsByCategory:[String:[UserEvent]] = [:]
            
            for event in events {
                if (eventsByCategory[event.category] != nil)
                {
                    eventsByCategory[event.category]!.insert(event, at:0)
                }
                else
                {
                    eventsByCategory[event.category] = [event]
                }
            }
            
            // Package with data (SUCCESS ✅)
            responseDict["events"] = events
            responseDict["eventsByCategory"] = eventsByCategory
            
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
    
    
    
    
    func getPoints(userId: String, completion: @escaping ([String:Any])->Void)
    {
        apolloClient.fetch(query: SHPESchema.GetPointsQuery(userId: userId))
        {
            response in
            
            guard let data = try? response.get().data,
                  let fallPoints = data.getUser?.fallPoints as? Int,
                  let springPoints = data.getUser?.springPoints as? Int,
                  let summerPoints = data.getUser?.summerPoints as? Int
            else
            {
                print("ERROR: Incomplete Request\nError Message:\(response)")
                
                // Package with data (ERROR ❌)
                completion(["error":"Incomplete Request"])
                return
            }
            
            // Package with data (SUCCESS ✅)
            let responseDict = [
                "fallPoints": fallPoints,
                "springPoints": springPoints,
                "summerPoints": summerPoints
            ]
            
            completion(responseDict)
        }
    }
    
    
    
    func getUserEvents(userId: String, completion: @escaping ([String:Any])->Void)
    {
        apolloClient.fetch(query: SHPESchema.GetUserEventsQuery(userId: userId))
        {
            response in
            
            guard let data = try? response.get().data,
                  let events = data.getUser?.events.map({ event in
                      let formatter = DateFormatter()
                      formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'" // Match the date format exactly to the string
                      formatter.timeZone = TimeZone(secondsFromGMT: 0) // Set timezone to UTC
                      if let eventName = event?.name,
                          let category = event?.category,
                          let points = event?.points,
                          let dateString = event?.createdAt,
                          let date = formatter.date(from: dateString),
                          let id = event?.id
                      {
                          return UserEvent(id: id, name: eventName, category: category, points: Int(points), date: date)
                      }
                      else
                      {
                          return UserEvent(id: "", name: "none", category: "", points: -1, date: Date(timeIntervalSince1970: 0))
                      }
                  })
            else
            {
                print("ERROR: Incomplete Request\nError Message:\(response)")
                
                // Package with data (ERROR ❌)
                completion(["error":"Incomplete Request"])
                return
            }
            
            var eventsByCategory:[String:[UserEvent]] = [:]
            
            for event in events {
                if (eventsByCategory[event.category] != nil)
                {
                    eventsByCategory[event.category]!.insert(event, at: 0)
                }
                else
                {
                    eventsByCategory[event.category] = [event]
                }
            }
            
            // Package with data (SUCCESS ✅)
            let responseDict = [
                "events": events,
                "eventsByCategory": eventsByCategory
            ]
            
           
            
            completion(responseDict)
        }
    }
    
    // MARK: Profile Page

    /*
        Input:
            firstName: String
            lastName: String
            classes: [String]
            country: String
            ethnicity: String
            graduatingYear: String
            internships: [String]
            major: String
            photo: String
            gender: String
            links: [String]
            year: String
            email: String
        Output:
            Bool
      */

    func postEditsToProfile(firstName:String, lastName: String, classes: [String], country: String, ethnicity:String, graduationYear:String, internships: [String], major:String, photo:String, gender:String, links:[String], year:String, email:String, completion: @escaping (([String: Any])->Void))
    {
        let classesValues = {
            var array:Array<String?> = []
            for value in classes {
                array.append(value)
            }
            return array
        }()
        
        let internshipValues = {
            var array:Array<String?> = []
            for value in internships {
                array.append(value)
            }
            return array
        }()
        
        let linkValues = {
            var array:Array<String?> = []
            for value in links {
                array.append(value)
            }
            return array
        }()
        
        apolloClient.perform(mutation: SHPESchema.EditUserProfileMutation(editUserProfileInput:GraphQLNullable( SHPESchema.EditUserProfileInput(email: email, firstName: firstName, lastName: lastName, photo: "data:image/jpeg;base64," + photo, major: major, year: year, graduating: graduationYear, country: country, ethnicity: ethnicity, sex: gender, classes: .some(classesValues), internships: .some(internshipValues), socialMedia: .some(linkValues)))))
        {
            response in
            
            guard (try? response.get().data) != nil
            else
            {
                print("ERROR: Incomplete Request\nError Message:\(response)")
                
                // Package with data (ERROR ❌)
                completion(["error":"Incomplete Request"])
                return
            }
            
            completion(["success":true])
            return
        }
    }
    
    /// Fetches the permission string for a given user ID via Apollo GraphQL
    /// - Parameters:
    ///   - userId: The unique identifier of the user
    ///   - completion: Closure returning the permission string or nil on error
    func fetchUserPermission(userId: String, completion: @escaping (String?) -> Void) {
        // Ensure a valid userId is provided
        guard !userId.isEmpty else {
            completion(nil)
            return
        }

        // Perform the GraphQL query
        apolloClient.fetch(query: SHPESchema.GetUserPermissionQuery(userId: userId)) { response in
            DispatchQueue.main.async {
                // Attempt to extract data from the response
                guard let data = try? response.get().data else {
                    print("❌ ERROR: Failed to fetch user permission: \(response)")
                    completion(nil)
                    return
                }

                // Retrieve the permission string from the fetched user
                let permission = data.getUser?.permission
                completion(permission)
            }
        }
    }


    /// Performs the `CreateEvent` GraphQL mutation and returns the result via a callback.
    /// - Parameters:
    ///   - input: The `CreateEventInput` object containing event details.
    ///   - completion: Closure returning a dictionary with event fields on success or an "error" key on failure.
    func createEvent(
        input: SHPESchema.CreateEventInput,
        completion: @escaping ([String: Any]) -> Void
    ) {
        // Wrap the input to handle nullable GraphQL fields
        let validInput = GraphQLNullable(input)

        // Execute the mutation using Apollo client
        apolloClient.perform(
            mutation: SHPESchema.CreateEventMutation(createEventInput: validInput)
        ) { result in
            switch result {

            case .success(let graphQLResult):
                // 1) Handle any GraphQL-level errors (returned by server schema)
                if let gqlErrors = graphQLResult.errors, !gqlErrors.isEmpty {
                    // Combine all error messages into one string
                    let messages = gqlErrors.map { $0.localizedDescription }
                                             .joined(separator: "\n")
                    completion(["error": messages])
                    return
                }

                // 2) Safely drill into nested data: data.createEvent is [CreateEvent?]
                guard
                    let data         = graphQLResult.data,
                    let rawList      = data.createEvent,      // Array of optional CreateEvent
                    let firstElement = rawList.first,          // Optional CreateEvent element
                    let event        = firstElement            // Unwrapped CreateEvent
                else {
                    // Data missing or malformed
                    completion(["error": "Event not returned"])
                    return
                }

                // 3) On success, extract event properties into a dictionary
                completion([
                    "category":   event.category,
                    "code":       event.code,
                    "expiration": event.expiration,
                    "name":       event.name,
                    "points":     event.points,
                    "request":    event.request
                ])

            case .failure(let error):
                // Network or parsing failure
                completion(["error": error.localizedDescription])
            }
        }
    }

    func deleteUser(email: String, completion: @escaping (([String: Any])->Void))
    {
        apolloClient.perform(mutation: SHPESchema.DeleteUserMutation(email: email))
        {
            response in
            
            guard (try? response.get().data) != nil
            else
            {
                print("ERROR: Incomplete Request\nError Message:\(response)")
                
                // Package with data (ERROR ❌)
                completion(["error":"Incomplete Request"])
                return
            }
            
            completion(["success":true])
            return
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
        guard let CALENDAR_ID = ACCESS["CALENDAR_ID"] else
        {
            print("CALENDAR_ID is missing from environment variables")
            completion(([],false,"FATAL_ERROR"))
            return
        }
        guard let CALENDAR_API_KEY = ACCESS["CALENDAR_API_KEY"] else
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
                            if let items = jsonObject["items"] as? (any Sequence)
                            {
                                for item in items
                                {
                                    guard let object = item as? [String:Any] else
                                    {
                                        completion(([],false,"PARSE_ERROR"))
                                        return
                                    }

                                    do {
                                        let event = try self.extractEvent(from: object)
                                        eventsList.append(event)
                                    } catch {
                                        let summary = object["summary"] as? String ?? "<No summary>"
                                        let startDict = object["start"] as? [String: Any]
                                        let dateTime = startDict?["dateTime"] as? String ?? startDict?["date"] as? String ?? "<No dateTime>"
                                        print("❌ Failed to parse event: \n \(summary) :\n DateTime:\n \(dateTime)")
                                        print("Reason: \(error.localizedDescription)")
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
        let description = dictionary["description"] as? String ?? nil

        let event = Event(
            created: created,
            creator: creator,
            end: end,
            etag: etag,
            eventType: eventType,
            htmlLink: htmlLink,
            iCalUID: iCalUID,
            identifier: id,
            kind: kind,
            organizer: organizer,
            sequence: sequence,
            start: start,
            status: status,
            summary: summary,
            updated: updated,
            location: location,
            description: description
        )
        
        return event
    }

    // Helper functions to extract nested objects
    private func extractCreator(from dictionary: [String: Any]) throws -> Creator {
        guard
            let email = dictionary["email"] as? String,
            let selfValue = (dictionary["self"] as? Bool) == true ? 1 : 0
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
            let selfValue = (dictionary["self"] as? Bool) == true ? 1 : 0
        else {
            throw NSError(domain: "ParsingError", code: 1, userInfo: nil)
        }

        return Organizer(email: email, selfValue: selfValue)
    }
}
