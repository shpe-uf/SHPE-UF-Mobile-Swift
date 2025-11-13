//
//  HomeViewModelTests.swift
//  SHPE-UF-Mobile-SwiftTests
//
//  Unit tests for HomeViewModel
//

import XCTest
import CoreData
@testable import SHPE_UF_Mobile_Swift
import SwiftUI

final class HomeViewModelTests: XCTestCase {

    var viewModel: HomeViewModel!
    var mockContext: NSManagedObjectContext!
    var mockFetchedResults: FetchedResults<CalendarEvent>!

    override func setUpWithError() throws {
        try super.setUpWithError()

        // Create an in-memory Core Data stack for testing
        let persistentContainer = NSPersistentContainer(name: "CoreUserModel")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        persistentContainer.persistentStoreDescriptions = [description]

        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Failed to load in-memory store: \(error)")
            }
        }

        mockContext = persistentContainer.viewContext
    }

    override func tearDownWithError() throws {
        viewModel = nil
        mockContext = nil
        mockFetchedResults = nil
        try super.tearDownWithError()
    }

    // MARK: - Test Dummy Events Creation

    func testCreateDummyEvents() throws {
        // Given
        let fetchRequest = CalendarEvent.fetchRequest()
        let emptyFetchedResults = try mockContext.fetch(fetchRequest)

        // When
        viewModel = HomeViewModel(
            coreEventsArray: emptyFetchedResults,
            viewContext: mockContext,
            loadMode: .dummyOnly
        )

        // Then
        XCTAssertFalse(viewModel.events.isEmpty, "Dummy events should be created")
        XCTAssertEqual(viewModel.events.count, 3, "Should create 3 dummy events")

        // Verify event types are correctly assigned
        let gbmEvents = viewModel.events.filter { $0.eventType == "GBM" }
        let socialEvents = viewModel.events.filter { $0.eventType == "Social" }
        let workshopEvents = viewModel.events.filter { $0.eventType == "Workshop" }

        XCTAssertEqual(gbmEvents.count, 1, "Should have 1 GBM event")
        XCTAssertEqual(socialEvents.count, 1, "Should have 1 Social event")
        XCTAssertEqual(workshopEvents.count, 1, "Should have 1 Workshop event")
    }

    func testDummyEventsHaveValidData() throws {
        // Given
        let fetchRequest = CalendarEvent.fetchRequest()
        let emptyFetchedResults = try mockContext.fetch(fetchRequest)

        // When
        viewModel = HomeViewModel(
            coreEventsArray: emptyFetchedResults,
            viewContext: mockContext,
            loadMode: .dummyOnly
        )

        // Then
        for event in viewModel.events {
            XCTAssertFalse(event.summary.isEmpty, "Event summary should not be empty")
            XCTAssertFalse(event.identifier.isEmpty, "Event identifier should not be empty")
            XCTAssertNotNil(event.location, "Event should have a location")
            XCTAssertTrue(event.end.dateTime > event.start.dateTime, "Event end should be after start")
        }
    }

    // MARK: - Test Event Type Classification

    func testUpdateEventTypes_GBM() throws {
        // Given
        let fetchRequest = CalendarEvent.fetchRequest()
        let emptyFetchedResults = try mockContext.fetch(fetchRequest)
        viewModel = HomeViewModel(
            coreEventsArray: emptyFetchedResults,
            viewContext: mockContext,
            loadMode: .dummyOnly
        )

        // When
        let gbmEvent = viewModel.events.first { $0.summary.contains("GBM") }

        // Then
        XCTAssertNotNil(gbmEvent, "Should find a GBM event")
        XCTAssertEqual(gbmEvent?.eventType, "GBM", "Event type should be GBM")
    }

    func testUpdateEventTypes_Workshop() throws {
        // Given
        let fetchRequest = CalendarEvent.fetchRequest()
        let emptyFetchedResults = try mockContext.fetch(fetchRequest)
        viewModel = HomeViewModel(
            coreEventsArray: emptyFetchedResults,
            viewContext: mockContext,
            loadMode: .dummyOnly
        )

        // When
        let workshopEvent = viewModel.events.first { $0.summary.contains("Workshop") }

        // Then
        XCTAssertNotNil(workshopEvent, "Should find a Workshop event")
        XCTAssertEqual(workshopEvent?.eventType, "Workshop", "Event type should be Workshop")
    }

    func testUpdateEventTypes_Social() throws {
        // Given
        let fetchRequest = CalendarEvent.fetchRequest()
        let emptyFetchedResults = try mockContext.fetch(fetchRequest)
        viewModel = HomeViewModel(
            coreEventsArray: emptyFetchedResults,
            viewContext: mockContext,
            loadMode: .dummyOnly
        )

        // When
        let socialEvent = viewModel.events.first { $0.summary.contains("Social") || $0.summary.contains("Convention") }

        // Then
        XCTAssertNotNil(socialEvent, "Should find a Social event")
        XCTAssertEqual(socialEvent?.eventType, "Social", "Event type should be Social")
    }

    // MARK: - Test Upcoming Events Filter

    func testGetUpcomingEvents_FiltersCorrectly() throws {
        // Given
        let fetchRequest = CalendarEvent.fetchRequest()
        let emptyFetchedResults = try mockContext.fetch(fetchRequest)
        viewModel = HomeViewModel(
            coreEventsArray: emptyFetchedResults,
            viewContext: mockContext,
            loadMode: .dummyOnly
        )

        // When
        let upcomingEvents = viewModel.getUpcomingEvents()

        // Then
        for event in upcomingEvents {
            XCTAssertTrue(event.end.dateTime > Date(), "All upcoming events should end in the future")
        }
    }

    func testGetUpcomingEvents_ReturnsSortedEvents() throws {
        // Given
        let fetchRequest = CalendarEvent.fetchRequest()
        let emptyFetchedResults = try mockContext.fetch(fetchRequest)
        viewModel = HomeViewModel(
            coreEventsArray: emptyFetchedResults,
            viewContext: mockContext,
            loadMode: .dummyOnly
        )

        // When
        let upcomingEvents = viewModel.getUpcomingEvents()

        // Then
        if upcomingEvents.count > 1 {
            for i in 0..<(upcomingEvents.count - 1) {
                XCTAssertTrue(
                    upcomingEvents[i].start.dateTime <= upcomingEvents[i + 1].start.dateTime,
                    "Events should be sorted by start date"
                )
            }
        }
    }

    // MARK: - Test Events Sorting

    func testEventsAreSortedByStartDate() throws {
        // Given
        let fetchRequest = CalendarEvent.fetchRequest()
        let emptyFetchedResults = try mockContext.fetch(fetchRequest)

        // When
        viewModel = HomeViewModel(
            coreEventsArray: emptyFetchedResults,
            viewContext: mockContext,
            loadMode: .dummyOnly
        )

        // Then
        let events = viewModel.events
        if events.count > 1 {
            for i in 0..<(events.count - 1) {
                XCTAssertTrue(
                    events[i].start.dateTime <= events[i + 1].start.dateTime,
                    "Events should be sorted by start date ascending"
                )
            }
        }
    }

    // MARK: - Test Core Data Saving

    func testSaveEventsToCoreData() throws {
        // Given
        let fetchRequest = CalendarEvent.fetchRequest()
        let emptyFetchedResults = try mockContext.fetch(fetchRequest)

        // When
        viewModel = HomeViewModel(
            coreEventsArray: emptyFetchedResults,
            viewContext: mockContext,
            loadMode: .dummyOnly
        )

        // Then - fetch saved events from Core Data
        let savedEvents = try mockContext.fetch(fetchRequest)

        XCTAssertEqual(savedEvents.count, viewModel.events.count, "All events should be saved to Core Data")

        // Verify event data was saved correctly
        for savedEvent in savedEvents {
            XCTAssertNotNil(savedEvent.identifier, "Saved event should have an identifier")
            XCTAssertNotNil(savedEvent.summary, "Saved event should have a summary")
            XCTAssertNotNil(savedEvent.start, "Saved event should have a start date")
            XCTAssertNotNil(savedEvent.end, "Saved event should have an end date")
            XCTAssertNotNil(savedEvent.eventType, "Saved event should have an event type")
        }
    }

    // MARK: - Test Load Modes

    func testLoadMode_DummyOnly() throws {
        // Given
        let fetchRequest = CalendarEvent.fetchRequest()
        let emptyFetchedResults = try mockContext.fetch(fetchRequest)

        // When
        viewModel = HomeViewModel(
            coreEventsArray: emptyFetchedResults,
            viewContext: mockContext,
            loadMode: .dummyOnly
        )

        // Then
        XCTAssertEqual(viewModel.events.count, 3, "DummyOnly mode should load exactly 3 events")
    }

    // MARK: - Test Event Identifiers

    func testEventIdentifiersAreUnique() throws {
        // Given
        let fetchRequest = CalendarEvent.fetchRequest()
        let emptyFetchedResults = try mockContext.fetch(fetchRequest)

        // When
        viewModel = HomeViewModel(
            coreEventsArray: emptyFetchedResults,
            viewContext: mockContext,
            loadMode: .dummyOnly
        )

        // Then
        let identifiers = Set(viewModel.events.map { $0.identifier })
        XCTAssertEqual(identifiers.count, viewModel.events.count, "All event identifiers should be unique")
    }

    // MARK: - Performance Tests

    func testPerformance_CreateDummyEvents() throws {
        let fetchRequest = CalendarEvent.fetchRequest()
        let emptyFetchedResults = try mockContext.fetch(fetchRequest)

        measure {
            viewModel = HomeViewModel(
                coreEventsArray: emptyFetchedResults,
                viewContext: mockContext,
                loadMode: .dummyOnly
            )
        }
    }

    func testPerformance_GetUpcomingEvents() throws {
        let fetchRequest = CalendarEvent.fetchRequest()
        let emptyFetchedResults = try mockContext.fetch(fetchRequest)
        viewModel = HomeViewModel(
            coreEventsArray: emptyFetchedResults,
            viewContext: mockContext,
            loadMode: .dummyOnly
        )

        measure {
            _ = viewModel.getUpcomingEvents()
        }
    }
}
