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
    let apolloClient = ApolloClient(url: URL(string: "http://127.0.0.1:5000/")!) // MUST BE NGROK URL or http://127.0.0.1:5000/
    
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
    
    func sampleRequest()
    {
        print("Making sample request now")
        apolloClient.fetch(query: SHPESchema.ExampleQuery()) { result in
          guard let data = try? result.get().data else { return }
            print(data.getUsers as Any) // Luke Skywalker
        }
    }
    
    func alumniRequest()
    {
        print("Making Alumni request now")
        apolloClient.fetch(query: SHPESchema.GetAlumnisQuery()) { result in
          guard let data = try? result.get().data else { return }
            print(data.getAlumnis?[0]?.firstName as Any) // Luke Skywalker
        }
    }
}

