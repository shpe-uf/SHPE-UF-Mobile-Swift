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
            caption: "Throwback to our last Barbeque with Industry! 🔥 #SHPEUF",
            media_type: "IMAGE",
            media_url: "https://shpeuf.s3.amazonaws.com/public/home/home-2.jpg",
            permalink: "https://www.instagram.com/p/1/"
        ),
        InstagramPost(
            id: "2",
            caption: "Engineering Research Symposium! 💡🤝",
            media_type: "IMAGE",
            media_url: "https://shpeuf.s3.amazonaws.com/public/home/home-3.jpg",
            permalink: "https://www.instagram.com/p/2/"
        ),
        InstagramPost(
            id: "3",
            caption: "Excited to kick off our Spring Semester! 🚀 #UF #SHPE",
            media_type: "IMAGE",
            media_url: "https://shpeuf.s3.amazonaws.com/public/resources/resourceImage.png",
            permalink: "https://www.instagram.com/p/3/"
        ),
        InstagramPost(
            id: "4",
            caption: "Our annual GTF was a huge success! 🌱.",
            media_type: "IMAGE",
            media_url: "https://shpeuf.s3.amazonaws.com/public/home/home-1.jpg",
            permalink: "https://www.instagram.com/p/4/"
        )
    ]
    
}
