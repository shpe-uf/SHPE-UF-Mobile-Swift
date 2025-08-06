import SwiftUI

/// **SocialsView:** Displays links to SHPE UF's social media.
struct SocialsView: View {
    @Binding var showView: String
    @Environment(\.colorScheme) var colorScheme // Detects system's dark/light mode

    /// **Social media links and their corresponding icons**
    let socials: [(String, String, String)] = [
        ("SHPE UF", "shpeuf_social_icon", "https://www.instagram.com/shpeuf"),
        ("FYLP", "family_group_icon", "https://www.instagram.com/fylp.shpeuf"),
        ("MentorSHPE", "mentorshpe_icon", "https://www.instagram.com/ufmentorshpe"),
        ("GradSHPE", "research_icon", "https://www.instagram.com/gradshpeuf"),
        ("PKY SHPE", "children_icon", "https://www.instagram.com/pky.shpe"),
        ("Linktree", "linktree-white-icon", "https://linktr.ee/shpeuf") // NEW LINKTREE BUTTON
    ]
    
    var body: some View {
        VStack() {
            
            // 🟠 Navigation Bar (EXACT MATCH TO NOTIFICATION VIEW)
            ZStack {
                Constants.orange
                    .frame(width: UIScreen.main.bounds.width, height: 100)
                HStack {
                    Button {
                        showView = "HomeView"
                    } label: {
                        Image("Back")
                            .frame(height: 75, alignment: .bottomLeading)
                    }
                    Spacer()
                    Text("Our Socials")
                        .font(Font.custom("Viga-Regular", size: 24))
                        .foregroundColor(.white)
                        .frame(height: 85, alignment: .bottomLeading)
                    Spacer()
                }
                .padding(.horizontal, 20)
            }
            .backgroundStyle(.red)
            
            // 🟠 Main Content
            ZStack {
                VStack(spacing:50) {
                    Text("Tap an icon to visit our social media")
                        .font(Font.custom("Viga-Regular", size: 20))
                        .multilineTextAlignment(.center)
                        .foregroundColor(colorScheme == .dark ? Constants.lightTextColor : Constants.DayNumberTextColor)
                        .frame(height: 50, alignment: .bottomLeading)
                        .padding(.top, 100)
                    
                    // First row: three buttons
                    HStack(spacing: 30) {
                        socialButton(name: socials[0].0, icon: socials[0].1, link: socials[0].2)
                        socialButton(name: socials[1].0, icon: socials[1].1, link: socials[1].2)
                        socialButton(name: socials[2].0, icon: socials[2].1, link: socials[2].2)
                    }
                    
                    // Second row: three buttons (INCLUDING NEW LINKTREE)
                    HStack(spacing: 30) {
                        socialButton(name: socials[3].0, icon: socials[3].1, link: socials[3].2)
                        socialButton(name: socials[4].0, icon: socials[4].1, link: socials[4].2)
                        socialButton(name: socials[5].0, icon: socials[5].1, link: socials[5].2) // SHPE UF LINKTREE
                    }
                    Spacer()
                }
            }
        }
        .background(colorScheme == .dark ? Constants.darkModeBackground : Constants.BackgroundColor)
        .edgesIgnoringSafeArea(.all)
        .navigationBarHidden(true)
    }

    /// **Helper function for creating social media buttons**
    private func socialButton(name: String, icon: String, link: String) -> some View {
        VStack(spacing: 20) {
            Button(action: {
                print("Attempting to open: \(link)")
                guard let url = URL(string: link) else {
                    print("Invalid URL: \(link)")
                    return
                }
                
                // Check if we can open the URL
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url) { success in
                        print("URL opened successfully: \(success)")
                    }
                } else {
                    print("Cannot open URL: \(link)")
                }
            }) {
                ZStack {
                    Image("Ellipse")
                        .frame(width: 92, height: 90)
                    Image(icon)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 42, height: 42)
                }
            }
            .buttonStyle(PlainButtonStyle())
            
            Text(name)
                .font(Font.custom("UniversLTStd", size: 16))
                .foregroundColor(colorScheme == .dark ? Constants.lightTextColor : Constants.DayNumberTextColor)
        }
    }
}
