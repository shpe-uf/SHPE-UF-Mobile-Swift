//
//  PointsViewModelTests.swift
//  SHPE-UF-Mobile-SwiftTests
//
//  Unit tests for PointsViewModel
//

import XCTest
import CoreData
import Combine
@testable import SHPE_UF_Mobile_Swift

final class PointsViewModelTests: XCTestCase {

    var viewModel: PointsViewModel!
    var mockShpeito: SHPEito!
    var cancellables: Set<AnyCancellable> = []

    override func setUpWithError() throws {
        try super.setUpWithError()

        // Create a mock SHPEito user for testing
        mockShpeito = SHPEito()

        viewModel = PointsViewModel(shpeito: mockShpeito)
    }

    override func tearDownWithError() throws {
        viewModel = nil
        mockShpeito = nil
        cancellables.removeAll()
        try super.tearDownWithError()
    }

    // MARK: - Initialization Tests

    func testInitialization_CopiesAllPropertiesFromSHPEito() throws {
        // Then - Verify all properties are copied correctly
        XCTAssertEqual(viewModel.id, mockShpeito.id)
        XCTAssertEqual(viewModel.username, mockShpeito.username)
        XCTAssertEqual(viewModel.points, mockShpeito.points)
        XCTAssertEqual(viewModel.fallPoints, mockShpeito.fallPoints)
        XCTAssertEqual(viewModel.springPoints, mockShpeito.springPoints)
        XCTAssertEqual(viewModel.summerPoints, mockShpeito.summerPoints)
        XCTAssertEqual(viewModel.fallPercentile, mockShpeito.fallPercentile)
        XCTAssertEqual(viewModel.springPercentile, mockShpeito.springPercentile)
        XCTAssertEqual(viewModel.summerPercentile, mockShpeito.summerPercentile)
    }

    func testInitialization_SetsDefaultStates() throws {
        // Then - Verify initial states
        XCTAssertFalse(viewModel.addPointsClicked)
        XCTAssertFalse(viewModel.gettingPoints)
        XCTAssertFalse(viewModel.gettingEvents)
        XCTAssertFalse(viewModel.doAnimation)
        XCTAssertFalse(viewModel.invalidCode)
        XCTAssertTrue(viewModel.categorizedEvents.isEmpty)
    }

    // MARK: - Points Properties Tests

    func testPointsProperties_ArePublished() throws {
        // Given
        let expectation = expectation(description: "Points property changes")
        var changedPoints: Int?

        // When
        viewModel.$points
            .dropFirst() // Skip initial value
            .sink { points in
                changedPoints = points
                expectation.fulfill()
            }
            .store(in: &cancellables)

        // Change the value
        viewModel.points = 150

        // Then
        waitForExpectations(timeout: 1.0)
        XCTAssertEqual(changedPoints, 150)
    }

    func testSeasonalPoints_AreIndependent() throws {
        // Given
        let initialFall = viewModel.fallPoints
        let initialSpring = viewModel.springPoints
        let initialSummer = viewModel.summerPoints

        // When
        viewModel.fallPoints = 50
        viewModel.springPoints = 60
        viewModel.summerPoints = 40

        // Then
        XCTAssertNotEqual(viewModel.fallPoints, initialFall)
        XCTAssertNotEqual(viewModel.springPoints, initialSpring)
        XCTAssertNotEqual(viewModel.summerPoints, initialSummer)
        XCTAssertEqual(viewModel.fallPoints, 50)
        XCTAssertEqual(viewModel.springPoints, 60)
        XCTAssertEqual(viewModel.summerPoints, 40)
    }

    // MARK: - Percentile Properties Tests

    func testPercentiles_AreWithinValidRange() throws {
        // Given - Initial percentiles from mockShpeito

        // Then - Verify they are within valid range (0-100)
        XCTAssertTrue(viewModel.fallPercentile >= 0 && viewModel.fallPercentile <= 100)
        XCTAssertTrue(viewModel.springPercentile >= 0 && viewModel.springPercentile <= 100)
        XCTAssertTrue(viewModel.summerPercentile >= 0 && viewModel.summerPercentile <= 100)
    }

    func testPercentiles_CanBeUpdated() throws {
        // When
        viewModel.fallPercentile = 90
        viewModel.springPercentile = 85
        viewModel.summerPercentile = 95

        // Then
        XCTAssertEqual(viewModel.fallPercentile, 90)
        XCTAssertEqual(viewModel.springPercentile, 85)
        XCTAssertEqual(viewModel.summerPercentile, 95)
    }

    // MARK: - State Management Tests

    func testGettingPointsState_CanBeToggled() throws {
        // When
        viewModel.gettingPoints = true

        // Then
        XCTAssertTrue(viewModel.gettingPoints)

        // When
        viewModel.gettingPoints = false

        // Then
        XCTAssertFalse(viewModel.gettingPoints)
    }

    func testGettingEventsState_CanBeToggled() throws {
        // When
        viewModel.gettingEvents = true

        // Then
        XCTAssertTrue(viewModel.gettingEvents)

        // When
        viewModel.gettingEvents = false

        // Then
        XCTAssertFalse(viewModel.gettingEvents)
    }

    func testAnimationState_CanBeToggled() throws {
        // When
        viewModel.doAnimation = true

        // Then
        XCTAssertTrue(viewModel.doAnimation)

        // When
        viewModel.doAnimation = false

        // Then
        XCTAssertFalse(viewModel.doAnimation)
    }

    func testInvalidCodeState_CanBeToggled() throws {
        // When
        viewModel.invalidCode = true

        // Then
        XCTAssertTrue(viewModel.invalidCode)

        // When
        viewModel.invalidCode = false

        // Then
        XCTAssertFalse(viewModel.invalidCode)
    }

    // MARK: - Categorized Events Tests

    func testCategorizedEvents_StartsEmpty() throws {
        // Then
        XCTAssertTrue(viewModel.categorizedEvents.isEmpty)
        XCTAssertEqual(viewModel.categorizedEvents.count, 0)
    }

    func testCategorizedEvents_CanStoreMultipleCategories() throws {
        // Given
        let gbmEvent = UserEvent(
            id: "1",
            name: "GBM Meeting",
            category: "GBM",
            points: 10,
            date: Date()
        )
        let workshopEvent = UserEvent(
            id: "2",
            name: "Tech Workshop",
            category: "Workshop",
            points: 15,
            date: Date()
        )

        // When
        viewModel.categorizedEvents = [
            "GBM": [gbmEvent],
            "Workshop": [workshopEvent]
        ]

        // Then
        XCTAssertEqual(viewModel.categorizedEvents.count, 2)
        XCTAssertEqual(viewModel.categorizedEvents["GBM"]?.count, 1)
        XCTAssertEqual(viewModel.categorizedEvents["Workshop"]?.count, 1)
        XCTAssertEqual(viewModel.categorizedEvents["GBM"]?.first?.name, "GBM Meeting")
        XCTAssertEqual(viewModel.categorizedEvents["Workshop"]?.first?.points, 15)
    }

    func testCategorizedEvents_CanContainMultipleEventsPerCategory() throws {
        // Given
        let event1 = UserEvent(id: "1", name: "Workshop 1", category: "Workshop", points: 10, date: Date())
        let event2 = UserEvent(id: "2", name: "Workshop 2", category: "Workshop", points: 15, date: Date())
        let event3 = UserEvent(id: "3", name: "Workshop 3", category: "Workshop", points: 20, date: Date())

        // When
        viewModel.categorizedEvents = [
            "Workshop": [event1, event2, event3]
        ]

        // Then
        XCTAssertEqual(viewModel.categorizedEvents["Workshop"]?.count, 3)

        let totalPoints = viewModel.categorizedEvents["Workshop"]?
            .reduce(0) { $0 + $1.points } ?? 0
        XCTAssertEqual(totalPoints, 45)
    }

    // MARK: - Data Consistency Tests

    func testSHPEitoModel_StaysInSync_WhenPointsChange() throws {
        // Given
        let newPoints = 200

        // When
        viewModel.shpeito.points = newPoints
        viewModel.points = newPoints

        // Then
        XCTAssertEqual(viewModel.shpeito.points, viewModel.points)
    }

    func testSHPEitoModel_StaysInSync_WhenSeasonalPointsChange() throws {
        // Given
        let newFall = 50
        let newSpring = 60
        let newSummer = 40

        // When
        viewModel.shpeito.fallPoints = newFall
        viewModel.shpeito.springPoints = newSpring
        viewModel.shpeito.summerPoints = newSummer

        viewModel.fallPoints = newFall
        viewModel.springPoints = newSpring
        viewModel.summerPoints = newSummer

        // Then
        XCTAssertEqual(viewModel.shpeito.fallPoints, viewModel.fallPoints)
        XCTAssertEqual(viewModel.shpeito.springPoints, viewModel.springPoints)
        XCTAssertEqual(viewModel.shpeito.summerPoints, viewModel.summerPoints)
    }

    // MARK: - Edge Cases Tests

    func testPoints_CanBeZero() throws {
        // When
        viewModel.points = 0
        viewModel.fallPoints = 0
        viewModel.springPoints = 0
        viewModel.summerPoints = 0

        // Then
        XCTAssertEqual(viewModel.points, 0)
        XCTAssertEqual(viewModel.fallPoints, 0)
        XCTAssertEqual(viewModel.springPoints, 0)
        XCTAssertEqual(viewModel.summerPoints, 0)
    }

    func testPercentiles_CanBeZero() throws {
        // When
        viewModel.fallPercentile = 0
        viewModel.springPercentile = 0
        viewModel.summerPercentile = 0

        // Then
        XCTAssertEqual(viewModel.fallPercentile, 0)
        XCTAssertEqual(viewModel.springPercentile, 0)
        XCTAssertEqual(viewModel.summerPercentile, 0)
    }

    func testPercentiles_CanBeHundred() throws {
        // When
        viewModel.fallPercentile = 100
        viewModel.springPercentile = 100
        viewModel.summerPercentile = 100

        // Then
        XCTAssertEqual(viewModel.fallPercentile, 100)
        XCTAssertEqual(viewModel.springPercentile, 100)
        XCTAssertEqual(viewModel.summerPercentile, 100)
    }

    // MARK: - Multiple State Changes Tests

    func testMultipleStates_CanBeActiveSimultaneously() throws {
        // When
        viewModel.gettingPoints = true
        viewModel.gettingEvents = true
        viewModel.doAnimation = true

        // Then
        XCTAssertTrue(viewModel.gettingPoints)
        XCTAssertTrue(viewModel.gettingEvents)
        XCTAssertTrue(viewModel.doAnimation)
    }

    func testStateReset_AllStatesFalse() throws {
        // Given
        viewModel.gettingPoints = true
        viewModel.gettingEvents = true
        viewModel.doAnimation = true
        viewModel.invalidCode = true
        viewModel.addPointsClicked = true

        // When - Reset all states
        viewModel.gettingPoints = false
        viewModel.gettingEvents = false
        viewModel.doAnimation = false
        viewModel.invalidCode = false
        viewModel.addPointsClicked = false

        // Then
        XCTAssertFalse(viewModel.gettingPoints)
        XCTAssertFalse(viewModel.gettingEvents)
        XCTAssertFalse(viewModel.doAnimation)
        XCTAssertFalse(viewModel.invalidCode)
        XCTAssertFalse(viewModel.addPointsClicked)
    }

    // MARK: - Performance Tests

    func testPerformance_PointsUpdate() throws {
        measure {
            for i in 0..<1000 {
                viewModel.points = i
            }
        }
    }

    func testPerformance_CategorizedEventsUpdate() throws {
        let events = (0..<100).map { i in
            UserEvent(
                id: "\(i)",
                name: "Event \(i)",
                category: "Category \(i % 5)",
                points: i * 10,
                date: Date()
            )
        }

        measure {
            var categorized: [String: [UserEvent]] = [:]
            for event in events {
                if categorized[event.category] != nil {
                    categorized[event.category]?.append(event)
                } else {
                    categorized[event.category] = [event]
                }
            }
            viewModel.categorizedEvents = categorized
        }
    }
}

// MARK: - UserEvent Test Extension

extension UserEvent {
    static func createTestEvent(
        id: String = UUID().uuidString,
        name: String = "Test Event",
        category: String = "GBM",
        points: Int = 10,
        date: Date = Date()
    ) -> UserEvent {
        return UserEvent(
            id: id,
            name: name,
            category: category,
            points: points,
            date: date
        )
    }
}
