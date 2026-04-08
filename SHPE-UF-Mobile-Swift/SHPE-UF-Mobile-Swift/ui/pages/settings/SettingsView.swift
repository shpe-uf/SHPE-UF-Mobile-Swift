//
//  SettingsView.swift
//  SHPE-UF-Mobile-Swift
//

import SwiftUI

struct SettingsView: View {

    @Environment(\.colorScheme) private var colorScheme

    // Notification toggles
    @State private var turnOnAll: Bool = true
    @State private var gbm: Bool = true
    @State private var infoSessions: Bool = false
    @State private var workshops: Bool = false
    @State private var volunteering: Bool = false
    @State private var socials: Bool = false

    private let instagramLinks: [(String, String)] = [
        ("SHPE UF",     "https://www.instagram.com/shpeuf/"),
        ("FYLP",        "https://www.instagram.com/shpeuf.fylp/"),
        ("MentorSHPE",  "https://www.instagram.com/mentorshpe.uf/"),
        ("GradSHPE",    "https://www.instagram.com/gradshpe.uf/"),
        ("PKY SHPE",    "https://www.instagram.com/pkyshpe/"),
        ("Linktree",    "https://linktr.ee/shpeuf"),
    ]

    var body: some View {
        ZStack {
            Color("darkdarkBlue")
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {

                    // MARK: Header
                    HStack {
                        Text("Settings")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)

                    }
                    .padding(.horizontal)
                    .padding(.top, 16)

                    // MARK: Notifications
                    SettingsSection(icon: "bell", title: "Notifications") {
                        SettingsToggleRow(label: "Turn on All", isOn: $turnOnAll)
                        Divider().background(Color.white.opacity(0.15))
                        SettingsToggleRow(label: "GBM", isOn: $gbm)
                        Divider().background(Color.white.opacity(0.15))
                        SettingsToggleRow(label: "Info Sessions", isOn: $infoSessions)
                        Divider().background(Color.white.opacity(0.15))
                        SettingsToggleRow(label: "Workshops", isOn: $workshops)
                        Divider().background(Color.white.opacity(0.15))
                        SettingsToggleRow(label: "Volunteering", isOn: $volunteering)
                        Divider().background(Color.white.opacity(0.15))
                        SettingsToggleRow(label: "Socials", isOn: $socials)
                    }

                    // MARK: Profile
                    SettingsSection(icon: "person", title: "Profile") {
                        SettingsNavRow(label: "Edit Profile") {}
                        Divider().background(Color.white.opacity(0.15))
                        SettingsNavRow(label: "Change Password") {}
                        Divider().background(Color.white.opacity(0.15))
                        SettingsNavRow(label: "Account Settings") {}
                    }

                    // MARK: Instagram Links
                    SettingsSection(icon: "camera", title: "Instagram Links") {
                        ForEach(instagramLinks, id: \.0) { item in
                            if item.0 != instagramLinks.first?.0 {
                                Divider().background(Color.white.opacity(0.15))
                            }
                            SettingsNavRow(label: item.0) {
                                if let url = URL(string: item.1) {
                                    UIApplication.shared.open(url)
                                }
                            }
                        }
                    }

                    Spacer(minLength: 40)
                }
                .padding(.horizontal)
            }
        }
    }
}

// MARK: - Section Container

private struct SettingsSection<Content: View>: View {
    let icon: String
    let title: String
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .foregroundColor(.white)
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
            }
            .padding(.bottom, 12)

            VStack(spacing: 0) {
                content()
            }
            .background(Color.white.opacity(0.07))
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
    }
}

// MARK: - Toggle Row

private struct SettingsToggleRow: View {
    let label: String
    @Binding var isOn: Bool

    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.white)
                .font(.body)
            Spacer()
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .tint(Color("profile-orange"))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}

// MARK: - Navigation Row

private struct SettingsNavRow: View {
    let label: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text(label)
                    .foregroundColor(.white)
                    .font(.body)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.white.opacity(0.5))
                    .font(.footnote)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
        }
    }
}

#Preview {
    SettingsView()
}
