//
//  InstagramPost.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by David Denis on 2/18/25.
//

import Foundation

struct InstagramPost: Identifiable, Decodable {
    let id: String
    let caption: String?
    let media_type: String
    let media_url: String
    let permalink: String
}

@Observable
class InstagramViewModel {
    var posts: [InstagramPost] = []
    
    func fetchPosts() async throws {
        
        let urlString = ""
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        // Instagram Returns data in a wrapper
        
        struct Wrapper: Decodable {
            let data: [InstagramPost]
        }
        
        let decoder = JSONDecoder()
        let wrapper = try decoder.decode(Wrapper.self, from: data)
        self.posts = wrapper.data
    }
    
}
