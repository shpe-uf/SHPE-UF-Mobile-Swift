import Foundation
import Apollo

enum Season: String, CaseIterable {
    case fall = "Fall"
    case spring = "Spring"
    case summer = "Summer"
}

class LeaderboardViewModel: ObservableObject {
    static let shared = LeaderboardViewModel()
    private init() {}

    @Published var members: [Member] = []
    @Published var ranked: [(rank: Int, member: Member)] = []
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    @Published var selectedSeason: Season = .fall {
        didSet { updateRanked() }
    }

    private let handler = RequestHandler()

    private func updateRanked() {
        let sorted = members.sorted {
            let p0 = $0.points(for: selectedSeason)
            let p1 = $1.points(for: selectedSeason)
            if p0 == p1 { return $0.name < $1.name }
            return p0 > p1
        }
        ranked = sorted.enumerated().map { (index, member) in
            (rank: index + 1, member: member)
        }
    }

    func fetch() {
        guard members.isEmpty else {
            return
        }

        DispatchQueue.main.async {
            self.isLoading = true
            self.errorMessage = nil
        }

        handler.fetchLeaderboard { result in
            DispatchQueue.main.async {
                self.isLoading = false
                if let error = result["error"] as? String {
                    self.errorMessage = "Failed to load: \(error)"
                } else if let raw = result["members"] as? [[String: Any]] {
                    self.members = raw.compactMap { dict in
                        guard let name = dict["name"] as? String,
                              let email = dict["email"] as? String else { return nil }
                        return Member(name: name,
                                      fallPoints: dict["fallPoints"] as? Int ?? 0,
                                      springPoints: dict["springPoints"] as? Int ?? 0,
                                      summerPoints: dict["summerPoints"] as? Int ?? 0,
                                      year: 0, email: email)
                    }
                    self.updateRanked()
                }
            }
        }
    }
}
