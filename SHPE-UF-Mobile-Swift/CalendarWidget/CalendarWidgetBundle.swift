//
//  CalendarWidgetBundle.swift
//  CalendarWidget
//
//  Created by David Denis on 2/26/25.
//

import WidgetKit
import SwiftUI

@main
struct CalendarWidgetBundle: WidgetBundle {
    var body: some Widget {
        CalendarWidget()
        CalendarWidgetControl()
    }
}
