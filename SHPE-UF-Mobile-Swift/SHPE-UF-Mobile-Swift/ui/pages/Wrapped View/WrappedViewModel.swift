//
//  WrappedViewModel.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by David Denis on 12/20/25.
//

import Foundation

final class WrappedViewModel: ObservableObject {
    
    // Navigation
    @Published var page: WrappedRoute = .intro
    @Published var isPaused: Bool = false
    @Published var hasStarted: Bool = false
    
    
    @Published var shpeito: SHPEito
    
    // MARK: Wrapped Data
    
    // CategoryView & CategoryBannerView
    @Published var topCategory: String = ""
    @Published var topcategoryCount: Int = 0
    
    
    // YearsView & YearsBannerView
    @Published var yearsInSHPE: Int = 0
    
    
    // OverallView & OverallBannerView
    @Published var overallTitle: String = ""
    // 'X-Cabinet Enthusiast'
    
    
    // WrappedIntroView
    @Published var mostActiveMonth: String = ""
    @Published var nextThreeMonths: [String] = []
    
    
    @Published var categorizedEvents: [String: [UserEvent]] = [:] {
        didSet {
            getTopCategory()
            computeActiveMonths()
            computeOverallTitle()
          }
    }
    
    
    // MARK: Pagination (Story Logic)
    @Published var progress: Double = 0
    @Published var timer: Timer?

    let duration: Double = 5.0
    let tick: Double = 0.02
    
    var isLastStory: Bool {
        page.rawValue == WrappedRoute.allCases.count - 1
    }
    
    init(SHPEito: SHPEito, categorizedEvents: [String: [UserEvent]]) {
        self.shpeito = SHPEito
        self.categorizedEvents = categorizedEvents
        
        // YearsView & YearsBannerView
        numberOfYearsInSHPE()
        
        // CategoryView & CategoryBannerView
        getTopCategory()
        
        // OverallView & OverallBannerView
        /// Network Call
        computeOverallTitle()
        
        // Most Active Months
        computeActiveMonths()
    }
    
    func numberOfYearsInSHPE() {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        let date = isoFormatter.date(from: self.shpeito.createdAt) ?? Date()
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.year], from: date, to: now)
        
        self.yearsInSHPE = components.year ?? 0
        
        print("Got number of years: \(self.yearsInSHPE)")
    }
    
    func getTopCategory() {
        guard let (category, events) = self.categorizedEvents.max(by: { $0.value.count < $1.value.count }) else {
            return
        }
        
        self.topCategory = category
        self.topcategoryCount = events.count
        
        print("Top Category: \(self.topCategory)")
        print("COUNT: \(self.topcategoryCount)")
    }
    
    
    func computeActiveMonths() {
        let allEvents = self.categorizedEvents.values.flatMap({$0})
        
        print("Total Events: \(allEvents.count)")
        
        guard !allEvents.isEmpty else {
            self.mostActiveMonth = ""
            self.nextThreeMonths = []
            return
        }
        
        // formatter for month name
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        
        // Count events per month
        let monthCount: [String : Int] = allEvents.reduce(into: [String: Int]()) { count, event in
            let month = formatter.string(from: event.date)
            count[month, default: 0] += 1
        }
        
        // sort based on month count
        let sortedMonths = monthCount.sorted(by: { $0.value > $1.value })
        
        guard sortedMonths.count > 1 else {
            self.mostActiveMonth = ""
            return
        }
        
        self.mostActiveMonth = sortedMonths.first!.key
        
        guard sortedMonths.count > 4 else {
            return
        }
        
        self.nextThreeMonths = Array(sortedMonths.dropFirst().prefix(3)).map(\.key)
    }
    
    func computeOverallTitle() {
//        let allEvents = self.categorizedEvents.values.flatMap({$0})
//        
//        guard !allEvents.isEmpty else {
//            self.overallTitle = ""
//            return
//        }
//        
//        // Count Event Category
//        let categoryCount: [String: Int] = allEvents.reduce(into: [String: Int]()) { count, event in
//            count[event.category, default: 0] += 1
//        }
//        
//        let category = categoryCount.max(by: { $0.value < $1.value })!.key
        
        self.overallTitle = enthusiastTitle(from: self.topCategory)
        
    }
    
    private func enthusiastTitle(from category: String) -> String {
        switch category {
        case "General Body Meeting":
            return "GBM"
        case "Workshop":
            return "Workshop"
        case "Cabinet Meeting":
            return "Cabinet"
        case "Corporate Event":
            return "Corporate"
        case "Social":
            return "Social"
        case "Miscellaneous":
            return "All-Around"
        default:
            return ""
        }
    }
    
    
    // MARK: Pagination
    
    func advancePage() {
        guard !isLastStory else {
            // Done, stop progress timer
            progress = 1
            pause()
            return
        }

        if let next = WrappedRoute(rawValue: page.rawValue + 1) {
            page = next
        }
    }
    
    // MARK: - Progress calculation

    func progressValue(for indicatorIndex: Int) -> Double {
        let pageIndex = page.rawValue - 1

        if indicatorIndex < pageIndex {
            return 1
        }

        if indicatorIndex == pageIndex {
            return isLastStory ? 1 : progress
        }

        return 0
    }

    // MARK: - Timer logic

    func startIfNeeded() {
        guard timer == nil else { return }
        progress = 0
        resume()
    }

    func pause() {
        timer?.invalidate()
        timer = nil
    }

    func resume() {
        guard timer == nil else { return }

        timer = Timer.scheduledTimer(withTimeInterval: tick, repeats: true) { [weak self] _ in
            guard let self else { return }
            guard !self.isPaused else { return }

            // If we're on the last story, freeze
            guard !self.isLastStory else {
                self.progress = 1
                self.pause()
                return
            }

            self.progress += self.tick / self.duration

            if self.progress >= 1 {
                self.progress = 0
                self.advancePage()
            }
        }
    }
    
    func resetProgressForNewPage() {
        progress = 0
    }
    
}
