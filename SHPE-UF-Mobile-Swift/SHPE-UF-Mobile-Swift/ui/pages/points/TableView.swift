//
//  TableView.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by David Denis on 2/15/24.
//

import SwiftUI


struct TableView: View {
    
    let events: [UserEvent]
    var title: String = "General Body Meeting"
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            VStack {
                Text(title.uppercased())
                    .font(Font.custom("Viga-Regular", size: 20))
                    .foregroundStyle(Constants.orange)
            }
            .padding()
        
            VStack(spacing: 0) {
                ForEach(events, id: \.self) { event in
                    SingleEventView(
                        name: event.name,
                        date: formattedDate(date: event.date),
                        points: event.points
                    )
                }
            }
        }
    }
}

func formattedDate(date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM/dd/yyyy" // Customize the date format here
    return dateFormatter.string(from: date)
}

