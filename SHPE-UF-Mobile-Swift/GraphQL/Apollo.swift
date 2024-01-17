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
    let apolloClient = ApolloClient(url: URL(string: "https://0ba8-128-227-1-20.ngrok-free.app/")!)
    
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

