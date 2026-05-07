//
//  Event.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by Daniel Parra on 2/8/24.
//

import Foundation

import Foundation

struct Event {
    let created: Date
    let creator: Creator
    let end: EventDateTime
    let etag: String
    var eventType: String
    let htmlLink: String
    let iCalUID: String
    let identifier: String
    let kind: String?
    let organizer: Organizer
    let sequence: Int
    let start: EventDateTime
    let status: String
    let summary: String
    let updated: Date
    let location: String?
    let description: String?
}

struct Creator {
    let email: String
    let selfValue: Int
}

struct EventDateTime {
    let dateTime: Date
    let timeZone: String
}

struct Organizer {
    let email: String
    let selfValue: Int
}

//MARK: Used for Event Testing in Calendar Page

extension Event {
    static var mock: Event {
        Event(
            created: Date(),
            creator: Creator(email: "creator@example.com", selfValue: 1),
            end: EventDateTime(dateTime: Calendar.current.date(byAdding: .hour, value: 8, to: Date())!, timeZone: "America/New_York"),
            etag: "etag12345",
            eventType: "Workshop",
            htmlLink: "https://example.com/event",
            iCalUID: "ical12345",
            identifier: "event12345",
            kind: "calendar#event",
            organizer: Organizer(email: "organizer@example.com", selfValue: 1),
            sequence: 1,
            start: EventDateTime(dateTime: Date(), timeZone: "America/New_York"),
            status: "confirmed",
            summary: "Mock Event for Previews",
            updated: Date(),
            location: "Gainesville, FL",
            description: "This is a mock event used for SwiftUI previews."
        )
    }
}

extension Event {
    static var mockArray: [Event] {
        let calendar = Calendar.current
        let now = Date()
        
        return (0..<10).map { i in
            let startDate = calendar.date(byAdding: .day, value: i, to: now)!
            let endDate = calendar.date(byAdding: .hour, value: 1, to: startDate)!
            
            return Event(
                created: now,
                creator: Creator(email: "creator\(i)@example.com", selfValue: 1),
                end: EventDateTime(dateTime: endDate, timeZone: "America/New_York"),
                etag: "etag\(i)",
                eventType: ["GBM", "Social", "Volunteering", "Workshop", "Info"].randomElement()!,
                htmlLink: "https://example.com/event\(i)",
                iCalUID: "ical\(i)",
                identifier: "event\(i)",
                kind: "calendar#event",
                organizer: Organizer(email: "organizer\(i)@example.com", selfValue: 1),
                sequence: i,
                start: EventDateTime(dateTime: startDate, timeZone: "America/New_York"),
                status: "confirmed",
                summary: "Mock Event \(i + 1)",
                updated: now,
                location: "1 Infinite Loop, Cupertino, CA",
                description: "Preview event \(i + 1)"
            )
        }
    }
}
