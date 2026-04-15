//
//  TestHelpers.swift
//  SHPE-UF-Mobile-SwiftTests
//
//  Helper utilities and mock objects for testing ViewModels
//

import Foundation
import CoreData
@testable import SHPE_UF_Mobile_Swift

// MARK: - Mock Core Data Stack

class MockCoreDataStack {

    static let shared = MockCoreDataStack()

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreUserModel")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]

        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Failed to load in-memory store: \(error)")
            }
        }

        return container
    }()

    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    func clearAllData() throws {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CalendarEvent.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        try viewContext.execute(deleteRequest)
        try viewContext.save()
    }
}

// MARK: - Event Factory

struct EventFactory {

    static func createTestEvent(
        identifier: String = UUID().uuidString,
        summary: String = "Test Event",
        eventType: String = "Social",
        start: Date = Date(),
        end: Date = Date().addingTimeInterval(3600),
        location: String? = "Test Location",
        description: String? = "Test Description"
    ) -> Event {
        return Event(
            created: Date(),
            creator: Creator(email: "test@example.com", selfValue: 0),
            end: EventDateTime(dateTime: end, timeZone: "UTC"),
            etag: "test-etag",
            eventType: eventType,
            htmlLink: "http://example.com",
            iCalUID: "test-ical-\(identifier)",
            identifier: identifier,
            kind: "calendar#event",
            organizer: Organizer(email: "organizer@example.com", selfValue: 0),
            sequence: 0,
            start: EventDateTime(dateTime: start, timeZone: "UTC"),
            status: "confirmed",
            summary: summary,
            updated: Date(),
            location: location,
            description: description
        )
    }

    static func createGBMEvent(daysFromNow: Int = 0) -> Event {
        let startDate = Calendar.current.date(byAdding: .day, value: daysFromNow, to: Date())!
        let endDate = Calendar.current.date(byAdding: .hour, value: 2, to: startDate)!

        return createTestEvent(
            summary: "GBM Meeting",
            eventType: "GBM",
            start: startDate,
            end: endDate,
            location: "Reitz Union",
            description: "General Body Meeting"
        )
    }

    static func createWorkshopEvent(daysFromNow: Int = 0) -> Event {
        let startDate = Calendar.current.date(byAdding: .day, value: daysFromNow, to: Date())!
        let endDate = Calendar.current.date(byAdding: .hour, value: 3, to: startDate)!

        return createTestEvent(
            summary: "Technical Workshop",
            eventType: "Workshop",
            start: startDate,
            end: endDate,
            location: "Engineering Building",
            description: "Hands-on coding workshop"
        )
    }

    static func createSocialEvent(daysFromNow: Int = 0) -> Event {
        let startDate = Calendar.current.date(byAdding: .day, value: daysFromNow, to: Date())!
        let endDate = Calendar.current.date(byAdding: .hour, value: 4, to: startDate)!

        return createTestEvent(
            summary: "Social Gathering",
            eventType: "Social",
            start: startDate,
            end: endDate,
            location: "Campus Plaza",
            description: "Social event for members"
        )
    }

    static func createMultiDayEvent(numberOfDays: Int = 3) -> Event {
        let startDate = Date()
        let endDate = Calendar.current.date(byAdding: .day, value: numberOfDays, to: startDate)!

        return createTestEvent(
            summary: "Multi-Day Conference",
            eventType: "Social",
            start: startDate,
            end: endDate,
            location: "Convention Center",
            description: "Multi-day event"
        )
    }
}

// MARK: - Core Data Helper

extension NSManagedObjectContext {

    func createTestCalendarEvent(
        identifier: String = UUID().uuidString,
        summary: String = "Test Core Event",
        start: Date = Date(),
        end: Date = Date().addingTimeInterval(3600),
        eventType: String = "Social"
    ) -> CalendarEvent {
        let event = CalendarEvent(context: self)
        event.identifier = identifier
        event.summary = summary
        event.start = start
        event.end = end
        event.eventType = eventType
        event.location = "Test Location"
        event.desc = "Test Description"
        return event
    }
}

// MARK: - Date Extensions for Testing

extension Date {

    static func daysFromNow(_ days: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: days, to: Date())!
    }

    static func hoursFromNow(_ hours: Int) -> Date {
        return Calendar.current.date(byAdding: .hour, value: hours, to: Date())!
    }

    func adding(days: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: days, to: self)!
    }

    func adding(hours: Int) -> Date {
        return Calendar.current.date(byAdding: .hour, value: hours, to: self)!
    }
}

// MARK: - XCTest Extensions

import XCTest

extension XCTestCase {

    func waitForAsync(timeout: TimeInterval = 1.0, description: String = "Async operation") {
        let expectation = expectation(description: description)
        DispatchQueue.main.asyncAfter(deadline: .now() + timeout - 0.1) {
            expectation.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }
}
