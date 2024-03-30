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
    let points: Int
    let date: Date
    
}
