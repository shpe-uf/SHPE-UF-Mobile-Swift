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
    let apolloClient = ApolloClient(url: URL(string: "https://0d3b-128-227-39-214.ngrok-free.app")!) // MUST BE NGROK URL or http://127.0.0.1:5000/
    
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
    
    // MARK: Home Page Functions
}

