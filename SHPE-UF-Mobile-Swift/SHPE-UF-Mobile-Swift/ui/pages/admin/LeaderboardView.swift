//
//  LeaderboardView.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by Gabi Garcia on 3/11/26.
//

import SwiftUI
import Foundation


struct Member: Identifiable, Codable {
    let id = UUID()
    var name: String
    var fallPoints: Int
    var springPoints: Int
    var summerPoints: Int
    var year: Int
    var email: String
    
    func points(for season: Season) -> Int {
        switch season {
        case .fall: return fallPoints
        case .spring: return springPoints
        case .summer: return summerPoints
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case fallPoints
        case springPoints
        case summerPoints
        case year
        case email
    }
}

struct LeaderboardView : View {
    
    @Environment(\.presentationMode) private var presentationMode
    
    @State private var leaderboard: [Member] = []
    @State private var isLoading: Bool = true
    @State private var errorMessage: String? = nil
    @State private var selectedSeason: Season = .fall
    
    
    let handler = RequestHandler()
    
    var sorted: [Member] {
        leaderboard.sorted {
            let p0 = $0.points(for: selectedSeason)
            let p1 = $1.points(for: selectedSeason)
            if p0 == p1 { return $0.name < $1.name }
            return p0 > p1
        }
    }
    
    
    var ranked : [(rank: Int, member: Member)] {
        sorted.enumerated().map { (index, member) in
            (rank: index + 1, member: member)
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ColoredTopView()
            Picker("Season", selection: $selectedSeason) {
                ForEach(Season.allCases, id: \.self) { season in
                    Text(season.rawValue).tag(season)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            .padding(.vertical, 8)
            
            if isLoading {
                Spacer()
                ProgressView("Loading leaderboard...")
                Spacer()
            } else if let error = errorMessage {
                Spacer()
                Text(error).foregroundColor(.red)
                Spacer()
            } else {
                ScrollView {
                    VStack(spacing: 12) {
                        if ranked.count >= 3 {
                            PodiumView(
                                first: (rank: 1, member: ranked[0].member),
                                second: (rank: 2, member: ranked[1].member),
                                third: (rank: 3, member: ranked[2].member),
                                season: selectedSeason
                            )
                            .padding(.vertical, 8)
                        }
                        if ranked.count > 3 {
                            ForEach(ranked[3...], id: \.member.id) {
                                item in LeaderboardRow(rank: item.rank, member: item.member, season: selectedSeason)
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .ignoresSafeArea()
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label : {
                    HStack {
                        Image(systemName: "chevron.backward")
                        Text("")
                    }
                    .foregroundStyle(.white)
                    .padding(.bottom, 20)
                }
            }
        }
        .onAppear {
            loadLeaderboard()
        }
    }
    
    
    private func loadLeaderboard() {
        isLoading = true
        errorMessage = nil
        
        handler.fetchLeaderboard { result in
            DispatchQueue.main.async {
                isLoading = false
                if let error = result["error"] as? String {
                    errorMessage = "Failed to load: \(error)"
                } else if let raw = result["members"] as? [[String: Any]] {
                    leaderboard = raw.compactMap { dict in
                        guard let name = dict["name"] as? String,
                              let email = dict["email"] as? String else { return nil }
                        return Member(name: name,
                                      fallPoints: dict["fallPoints"] as? Int ?? 0,
                                      springPoints: dict["springPoints"] as? Int ?? 0,
                                      summerPoints: dict["summerPoints"] as? Int ?? 0, year: 0, email: email)
                    }
                }
            }
        }
    }
}

struct PodiumView: View {
    let first: (rank: Int, member: Member)
    let second: (rank: Int, member: Member)
    let third: (rank: Int, member: Member)
    let season: Season
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 24) {
            PodiumCard(rank: second.rank, member: second.member, color: Color("SHPE light blue"), height: 75, season: season)
            PodiumCard(rank: first.rank, member: first.member, color: Color("SHPE light blue"), height: 100, season: season)
            PodiumCard(rank: third.rank, member: third.member, color: Color("SHPE light blue"), height: 50, season: season)
        }
        .padding(.horizontal)
    }
}


struct PodiumCard: View {
    let rank: Int
    let member: Member
    let color: Color
    let height: CGFloat
    let season: Season
    
    var medalImage: String? {
           switch rank {
           case 1: return "medal.fill"
           case 2: return "medal.fill"
           case 3: return "medal.fill"
           default: return nil
           }
       }
       
       var medalColor: Color {
           switch rank {
           case 1: return Color(red: 1.0, green: 0.84, blue: 0.0)  // Gold
           case 2: return Color(red: 0.75, green: 0.75, blue: 0.75) // Silver
           case 3: return Color(red: 0.80, green: 0.50, blue: 0.20) // Bronze
           default: return .secondary
           }
       }
    
    var body: some View {
        VStack(spacing: 8) {
            // Profile circle
            Circle()
                .fill(Color.blue.opacity(0.2))
                .frame(width: 50, height: 50)
                .overlay(
                    Text(member.name.prefix(1))
                        .font(.title2)
                        .fontWeight(.bold)
                )
            
            // Name
            Text(member.name)
                .font(.caption)
                .fontWeight(.semibold)
                .lineLimit(1)
            
            // Points
            Text("\(member.points(for: season)) pts")
                .font(.caption2)
                .foregroundColor(.secondary)
            
            // Podium base
            RoundedRectangle(cornerRadius: 8)
                .fill(color.opacity(0.3))
                .frame(height: height)
                .overlay(
                    Image(systemName: "medal.fill")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(medalColor)
                )
        }
        .frame(maxWidth: .infinity)
    }
}

struct LeaderboardRow: View {
    let rank: Int
    let member: Member
    let season: Season
    
    var body: some View {
        HStack(spacing: 16) {
            // Rank
            Text("#\(rank)")
                .font(.headline)
                .foregroundColor(.secondary)
                .frame(width: 40, alignment: .leading)
            
            // Profile circle
            Circle()
                .fill(Color.blue.opacity(0.2))
                .frame(width: 40, height: 40)
                .overlay(
                    Text(member.name.prefix(1))
                        .font(.headline)
                        .fontWeight(.bold)
                )
            
            // Name
            Text(member.name)
                .font(.body)
                .fontWeight(.medium)
            
            Spacer()
            
            // Points
            Text("\(member.points(for: season))")
                .font(.headline)
                .foregroundColor(.blue)
            
            Text("pts")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(12)
    }
}

struct ColoredTopView: View {
    var body: some View {
        ZStack(alignment: .bottom) {
            Rectangle()
                .foregroundColor(Color(red: 0.82, green: 0.35, blue: 0.09))
                .frame(width: UIScreen.main.bounds.width, height: 100)
            Text("LEADERBOARD")
                .font(Font.custom("Viga-Regular", size: 25)).bold()
                .foregroundStyle(.white)
                .padding(.top, 20)
                .padding()
        }
        .ignoresSafeArea()
    }
}
    
    
// Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            LeaderboardView()
        }
    }
}
