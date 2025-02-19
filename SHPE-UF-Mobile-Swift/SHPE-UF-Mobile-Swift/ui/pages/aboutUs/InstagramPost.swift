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


class InstagramViewModel: ObservableObject {
    @Published var posts: [InstagramPost] = []
    
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
    
    /// MOCK DATA
    var mockData: [InstagramPost] = [
        InstagramPost(
            id: "1",
            caption: "Excited to kick off our latest project! 🚀 #Innovation",
            media_type: "IMAGE",
            media_url: "https://images.unsplash.com/photo-1575936123452-b67c3203c357?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8aW1hZ2V8ZW58MHx8MHx8fDA%3D",
            permalink: "https://www.instagram.com/p/1/"
        ),
        InstagramPost(
            id: "2",
            caption: "Teamwork makes the dream work! 💡🤝",
            media_type: "IMAGE",
            media_url: "https://buffer.com/library/content/images/size/w1200/2023/10/free-images.jpg",
            permalink: "https://www.instagram.com/p/2/"
        ),
        InstagramPost(
            id: "3",
            caption: "Throwback to our last event! 🔥 #Community",
            media_type: "IMAGE",
            media_url: "https://th.bing.com/th/id/OIG3.x_FwnnM2OPeDWluswy.G",
            permalink: "https://www.instagram.com/p/3/"
        ),
        InstagramPost(
            id: "4",
            caption: "We’re growing fast! 🌱 Stay tuned for updates.",
            media_type: "IMAGE",
            media_url: "https://images.squarespace-cdn.com/content/v1/6213c340453c3f502425776e/1722636479289-OH0D6P61UQYXJ027RBA8/unsplash-image-nHFczgs6ppw.jpg?format=1500w",
            permalink: "https://www.instagram.com/p/4/"
        )
    ]
    
}
