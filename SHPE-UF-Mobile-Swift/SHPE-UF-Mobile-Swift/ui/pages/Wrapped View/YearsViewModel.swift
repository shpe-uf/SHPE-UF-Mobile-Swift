//
//  YearsViewModel.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by Alex Milanes on 10/2/25.
//


import SwiftUI

class YearsViewModel: ObservableObject {
    @Published var numYears: Int
    
    
    init(shpeito: SHPEito) {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        let date = isoFormatter.date(from: shpeito.createdAt)!
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.year], from: date, to: now)
        
        self.numYears = components.year!
        
        
    }
}
