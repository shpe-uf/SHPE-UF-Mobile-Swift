//
//  WidgetEvent.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by David Denis on 4/30/25.
//

import Foundation

struct WidgetEvent: Identifiable {
    let id = UUID()
    let title: String
    let startDate: Date
    let endDate: Date
    let eventType: String
}
