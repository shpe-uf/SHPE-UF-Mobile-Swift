//
//  NotificationViewModel.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by Matthew Segura on 2/17/24.
//

import SwiftUI
import UserNotifications

class NotificationViewModel : ObservableObject {
    
    static let instance  = NotificationViewModel()
    @ObservedObject var viewModel = HomeViewModel()
    
    func checkForPermission() {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .authorized:
                // Do something when notification permission is authorized
                print("Notification permission is authorized")
            case .denied:
                // Do something when notification permission is denied
                print("Notification permission is denied")
            case .notDetermined:
                notificationCenter.requestAuthorization(options: [.alert, .sound]) { didAllow, error in
                    if didAllow {
                        // Do something when notification permission is granted
                        print("Notification permission is granted")
                    }
                    if let error = error {
                        print("ERROR: \(error)")
                    }
                }
            default:
                break
            }
        }
    }
    
    
    func turnOnEventNotification(eventType: String) {
        for event in viewModel.events {
            if event.eventType == eventType {
                var notificationDate = event.start.dateTime
                if event.start.dateTime != event.end.dateTime {
                    // Notify 4 hours before the event start time
                    notificationDate = Calendar.current.date(byAdding: .hour, value: -4, to: event.start.dateTime)!
                } else {
                    // If the event is all-day, notify 12 hours before the start time
                    notificationDate = Calendar.current.date(byAdding: .hour, value: -12, to: event.start.dateTime)!
                }
                
                // Dispatch notification
                dispatchNotification(event: event, date: notificationDate)
                
                
                
                
            }
        }
    }
    
    func turnOffEventNotification(eventType: String) {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [eventType])
    }
    
    func dispatchNotification(event: Event, date: Date) {
        let identifier = event.eventType
        let title = "Upcoming Event: \(event.summary)"
        let body = "Event starts soon!"
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date), repeats: false)
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
        notificationCenter.add(request)
    }
}

