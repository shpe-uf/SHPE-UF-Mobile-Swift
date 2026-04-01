//
//  UserEvent.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by David Denis on 3/4/24.
//

import Foundation

struct UserEvent: Identifiable, Hashable {
    
    let id: String
    let name: String
    let category: String
   // let semester: String (SWE needs to fix it)
    let points: Int
    let date: Date
    
    var semester: Semester {
        let calendar = Calendar.current
        let month = calendar.component(.month, from: date)
        
        switch month {
        case 1...5:
            return Semester.spring
        case 6...8:
            return .summer
        case 9...12:
            return .fall
        default:
            return .unknown
        }
    }
}

enum Semester: String, CaseIterable {
    case spring = "Spring"
    case summer = "Summer"
    case fall = "Fall"
    case unknown = "Unknown"
}
