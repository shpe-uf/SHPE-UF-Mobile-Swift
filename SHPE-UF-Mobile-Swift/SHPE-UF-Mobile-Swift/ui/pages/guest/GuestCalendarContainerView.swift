//
//  GuestCalendarContainerView.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by Carlos Chavez on 3/3/25.
//

import SwiftUI

struct GuestCalendarContainerView: View {
    @FetchRequest(sortDescriptors: []) private var coreEvents: FetchedResults<CalendarEvent>
    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        let model = HomeViewModel(coreEvents: coreEvents, viewContext: viewContext)
        GuestCalendarView(viewModel: model)
    }
}
#Preview {
    GuestCalendarContainerView()
}
