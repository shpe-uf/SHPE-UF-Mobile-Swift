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
    let id: String
    let kind: String?
    let organizer: Organizer
    let sequence: Int
    let start: EventDateTime
    let status: String
    let summary: String
    let updated: Date
    let location: String?
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
