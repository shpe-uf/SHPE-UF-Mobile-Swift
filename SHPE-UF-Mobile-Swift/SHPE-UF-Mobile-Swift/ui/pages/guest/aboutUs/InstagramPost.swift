//
//  InstagramPost.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by David Denis on 2/18/25.
//

import Foundation
import SwiftUICore
import UIKit

struct InstagramPost: Identifiable, Decodable {
    let id: String
    let caption: String?
    let media_type: String
    let media_url: String
    let permalink: String
    let localImageName: String?  // NEW (optional)

    // Computed image for SwiftUI views
    var image: Image {
        if let local = localImageName, let uiImage = UIImage(named: local) {
            return Image(uiImage: uiImage)
        } else if let url = URL(string: media_url), let data = try? Data(contentsOf: url),
                  let uiImage = UIImage(data: data) {
            return Image(uiImage: uiImage)
        } else {
            return Image(systemName: "photo")  // Fallback
        }
    }
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
            media_url: "",
            permalink: "https://www.instagram.com/p/1/",
            localImageName: "insta1.jpg"
        ),
        InstagramPost(
            id: "2",
            caption: "Engineering Research Symposium! 💡🤝",
            media_type: "IMAGE",
            media_url: "",
            permalink: "https://www.instagram.com/p/2/",
            localImageName: "insta2.jpg"
        ),
        InstagramPost(
            id: "3",
            caption: "Excited to kick off our Spring Semester! 🚀 #UF #SHPE",
            media_type: "IMAGE",
            media_url: "",
            permalink: "https://www.instagram.com/p/3/",
            localImageName: "insta3.jpg"
        ),
        InstagramPost(
            id: "4",
            caption: "Our annual GTF was a huge success! 🌱.",
            media_type: "IMAGE",
            media_url: "",
            permalink: "https://www.instagram.com/p/4/",
            localImageName: "insta4.jpg"
        )
    ]
    
}
