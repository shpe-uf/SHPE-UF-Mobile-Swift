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
    
    @Published var isGBMSelected = false
    @Published var isInfoSelected = false
    @Published var isWorkShopSelected = false
    @Published var isVolunteeringSelected = false
    @Published var isSocialSelected = false
    
    private init () {}
    
    private func buttonClicked(eventType:String)
    {
        switch eventType {
        case "GBM":
            isGBMSelected.toggle()
        case "Info Sessions":
            isInfoSelected.toggle()
        case "Workshops":
            isWorkShopSelected.toggle()
        case "Volunteering":
            isVolunteeringSelected.toggle()
        case "Socials":
            isSocialSelected.toggle()
        default:
            print("Invalid Notificatiion Type")
        }
    }
    
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
        buttonClicked(eventType: eventType)
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
        buttonClicked(eventType: eventType)
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [eventType])
    }
    
    func dispatchNotification(event: Event, date: Date) {
        let identifier = event.eventType //TODO: Change this to event Id:::eventType
        
        let title = "Upcoming Event: \(event.summary)" //TODO: Change to event Title OR <EVENT_TYPE>: Title
        let body = "Event starts soon!" // Some message that gives information about time and location
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default // Kinda cool if we could make our own notification sound 👀
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date), repeats: false)
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        let notificationCenter = UNUserNotificationCenter.current()
        
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
        
        notificationCenter.add(request)
    }
}


