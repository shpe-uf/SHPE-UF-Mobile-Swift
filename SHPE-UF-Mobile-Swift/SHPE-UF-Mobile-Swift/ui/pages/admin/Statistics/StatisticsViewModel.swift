import Foundation
import SwiftUI

final class StatisticsViewModel: ObservableObject {

    static let shared = StatisticsViewModel()

    private init() {}

    private var requestHandler = RequestHandler()

    @Published var majorStats:     [(name: String, value: Int)] = []
    @Published var yearStats:      [(name: String, value: Int)] = []
    @Published var countryStats:   [(name: String, value: Int)] = []
    @Published var sexStats:       [(name: String, value: Int)] = []
    @Published var ethnicityStats: [(name: String, value: Int)] = []

    @Published var isLoading: Bool = false
    @Published var activeCategory: String = "Major"

    let categories = ["Major", "Year", "Country", "Gender", "Ethnicity"]

    func loadAll() {

        if !majorStats.isEmpty { return }

        isLoading = true
        let group = DispatchGroup()

        group.enter()
        requestHandler.getMajorStat { data in
            DispatchQueue.main.async {
                self.majorStats = self.parse(data)
                group.leave()
            }
        }

        group.enter()
        requestHandler.getYearStat { data in
            DispatchQueue.main.async {
                self.yearStats = self.parse(data)
                group.leave()
            }
        }

        group.enter()
        requestHandler.getCountryStat { data in
            DispatchQueue.main.async {
                self.countryStats = self.parse(data)
                group.leave()
            }
        }

        group.enter()
        requestHandler.getSexStat { data in
            DispatchQueue.main.async {
                self.sexStats = self.parse(data)
                group.leave()
            }
        }

        group.enter()
        requestHandler.getEthnicityStat { data in
            DispatchQueue.main.async {
                self.ethnicityStats = self.parse(data)
                group.leave()
            }
        }

        group.notify(queue: .main) {
            self.isLoading = false
        }
    }

    private func parse(_ data: [[String: Any]]) -> [(name: String, value: Int)] {
        return data.compactMap { item in
            guard let name = item["name"] as? String,
                  let value = item["value"] as? Int else { return nil }
            return (name: name, value: value)
        }.sorted { $0.value > $1.value }
    }

    func statsFor(category: String) -> [(name: String, value: Int)] {
        switch category {
        case "Major":     return majorStats
        case "Year":      return yearStats
        case "Country":   return countryStats
        case "Gender":    return sexStats
        case "Ethnicity": return ethnicityStats
        default:          return []
        }
    }

    func total(for category: String) -> Int {
        statsFor(category: category).reduce(0) { $0 + $1.value }
    }
}
