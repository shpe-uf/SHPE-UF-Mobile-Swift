//
//  CalendarSyncViewModel.swift
//  SHPE-UF-Mobile-Swift
//

import Foundation
import EventKit

/// Handles adding SHPE UF events to the user's device calendar via EventKit.
class CalendarSyncViewModel: ObservableObject {

    static let instance = CalendarSyncViewModel()

    private let eventStore = EKEventStore()
    private let addedEventsKey = "addedCalendarEventKeys"

    @Published var addedEventKeys: Set<String>

    private init() {
        addedEventKeys = Set(UserDefaults.standard.stringArray(forKey: addedEventsKey) ?? [])
    }

    private func key(for event: Event) -> String {
        event.identifier + ":::" + event.eventType
    }

    func isEventAdded(_ event: Event) -> Bool {
        addedEventKeys.contains(key(for: event))
    }

    func requestAccess(completion: @escaping (Bool) -> Void) {
        eventStore.requestFullAccessToEvents { granted, _ in
            DispatchQueue.main.async {
                completion(granted)
            }
        }
    }

    func addEvent(_ event: Event, completion: @escaping (Bool) -> Void) {
        let ekEvent = EKEvent(eventStore: eventStore)
        ekEvent.title = event.summary
        ekEvent.startDate = event.start.dateTime
        ekEvent.endDate = event.end.dateTime
        ekEvent.isAllDay = event.start.dateTime == event.end.dateTime
        ekEvent.location = event.location
        ekEvent.notes = event.description
        ekEvent.calendar = eventStore.defaultCalendarForNewEvents

        do {
            try eventStore.save(ekEvent, span: .thisEvent)
            addedEventKeys.insert(key(for: event))
            UserDefaults.standard.set(Array(addedEventKeys), forKey: addedEventsKey)
            completion(true)
        } catch {
            completion(false)
        }
    }
}
