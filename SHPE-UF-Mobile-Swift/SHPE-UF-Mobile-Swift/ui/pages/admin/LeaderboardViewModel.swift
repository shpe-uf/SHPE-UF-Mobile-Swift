import Foundation
import Apollo


struct LeaderboardMember: Identifiable {
    let id: String
    let name: String
    let fallPoints: Int
    let springPoints: Int
    let summerPoints: Int

    func points(for season : Season) -> Int {
        switch season {
        case .fall:   return fallPoints
        case .spring: return springPoints
        case .summer: return summerPoints
        }
    }
}

enum Season: String, CaseIterable {
    case fall = "Fall"
    case spring = "Spring"
    case summer = "Summer"
}

class LeaderboardViewModel: ObservableObject {
    @Published var members: [LeaderboardMember] = []
    @Published var isLoading = false
    @Published var selectedSeason: Season = .fall

    var ranked: [LeaderboardMember] {
        members.sorted { $0.points(for: selectedSeason) > $1.points(for: selectedSeason) }
    }

    func fetch() {
        //Connect when server is running
    }
}
