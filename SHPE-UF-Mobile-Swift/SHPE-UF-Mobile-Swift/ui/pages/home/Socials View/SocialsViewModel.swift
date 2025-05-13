//
//  SocialsViewModel.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by Mazin Saleh on 1/30/25.
//

import SwiftUI

class SocialsViewModel: ObservableObject {
    static let instance = SocialsViewModel()
    
    struct SocialLink {
        let name: String
        let icon: String
        let url: String
    }
    
    @Published var socials: [SocialLink] = [
        SocialLink(name: "Instagram", icon: "InstagramIcon", url: "https://www.instagram.com/shpeuf"),
        SocialLink(name: "TikTok", icon: "TikTokIcon", url: "https://www.tiktok.com/@shpeuf"),
        SocialLink(name: "LinkedIn", icon: "LinkedInIcon", url: "https://www.linkedin.com/company/shpe-uf"),
        SocialLink(name: "Facebook", icon: "FacebookIcon", url: "https://www.facebook.com/shpeuf"),
        SocialLink(name: "Website", icon: "WebsiteIcon", url: "https://www.shpeuf.com")
    ]
    
    private init() {}
}
