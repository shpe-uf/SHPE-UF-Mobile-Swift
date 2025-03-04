import WidgetKit
import CoreData
import SwiftUI

// Define an Event struct to use in the widget - matching your app's Event model
struct WidgetEvent: Identifiable {
    let id = UUID()
    let title: String
    let startDate: Date
    let endDate: Date
    let eventType: String
    
}

struct Provider: TimelineProvider {
    let dataManager: DataManager
    
    init(dataManager: DataManager) {
        self.dataManager = dataManager
    }
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), events: [])
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let events = fetchEventsDirectly()
        let entry = SimpleEntry(date: Date(), events: events)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
        let events = fetchEventsDirectly()
        
        var entries: [SimpleEntry] = []
        let currentDate = Date()
        
        // Create timeline entries for the next day hours
        print("GETTING TIMELINE")
        for hourOffset in 0..<24 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let upcomingEvents = events.filter { $0.startDate >= entryDate }
            let entry = SimpleEntry(date: entryDate, events: upcomingEvents)
            entries.append(entry)
        }
        
        completion(Timeline(entries: entries, policy: .atEnd))
    }
    
    // Method to directly fetch and format events from CoreData
    private func fetchEventsDirectly() -> [WidgetEvent] {
        print("FETCHING EVENTS")
        // initialize viewContext with DataManager class
        let viewContext = dataManager.container.viewContext
        
        // initialize fetch request from https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/CoreData/FetchingObjects.html
        
        let fetchRequest = NSFetchRequest<CalendarEvent>(entityName: "CalendarEvent")
        
        // Use NSPredicate to only get events that has happened after now '>='
        let currentDate = Date()
        fetchRequest.predicate = NSPredicate(format: "end >= %@", currentDate as NSDate)
        
        // only get 5 events per day
        fetchRequest.fetchLimit = 5
        
        // sort based on Date
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \CalendarEvent.start, ascending: true)]
        
        // fetch the coreEvents
        do {
            let coreEvents = try viewContext.fetch(fetchRequest)
            print("CORE EVNTS::: \(coreEvents)")
            return convertCoreEventsToEvents(coreEvents)
            
        } catch {
            print("ERROR FETCHING EEVENTS")
            fatalError(error.localizedDescription)
        }
        
    }
    
    // CoreData [event] to [WidgetEvent]
    private func convertCoreEventsToEvents(_ coreEvents: [CalendarEvent]) -> [WidgetEvent] {
        
        // use compact map to filter out unwanted objects
        let widgetEvents = coreEvents.compactMap { coreEvent in
            // check the required types
            guard let start = coreEvent.start as Date?,
                  let end = coreEvent.end as Date?,
                  let title = coreEvent.identifier as String?,
                  let eventType = coreEvent.eventType as String?
            else {
                return WidgetEvent(title: "", startDate: Date(), endDate: Date(), eventType: "")
            }
            
            // create the corresponding WidgetEvent
            return WidgetEvent(title: title, startDate: start, endDate: end, eventType: eventType)
        }
        
        return widgetEvents
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let events: [WidgetEvent]
}

struct CalendarWidgetEntryView: View {
    var entry: Provider.Entry
    
    @Environment(\.widgetFamily) var family
    
    @Environment(\.colorScheme) var colorScheme
    
    
    @ViewBuilder
    var body: some View {
        switch family {
        case .accessoryCircular:
            // circular accessory
            MediumCalendarWidget(events: entry.events)
        case .systemSmall:
            // small widget
            SmallCalendarWidget(events: entry.events)
                .environment(\.colorScheme, .dark)
        case .systemMedium:
            // medium widget.
            MediumCalendarWidget(events: entry.events)
                .environment(\.colorScheme, .dark)
        default:
            MediumCalendarWidget(events: entry.events)
        }
    }
}

struct SmallCalendarWidget: View {
    let events: [WidgetEvent]
    let formatter = DateFormatter()
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 2) {
                    
                    // Day Name
                    Text("\(formatDate(Date(), format: "EEEE"))")
                        .font(Font.custom("Viga-Regular", size: 15))
                        .foregroundStyle(Color(.rorange))
                    
                    HStack {
                        
                        //                        Text("\(formatDate(Date(), format: "MMM"))")
                        //                            .font(Font.custom("Viga-Regular", size: 15))
                        //                            .offset(y: -4)
                        
                        // Date Number
                        Text("\(formattedDayWithSuffix(Date()))")
                            .font(Font.custom("Viga-Regular", size: 30))
                        //.foregroundStyle(Color(.orangeButton))
                            .offset(y: -4)
                        
                    }
                    
                    // Event List
                    if events.isEmpty {
                        Text("No upcoming events")
                            .font(.body)
                            .foregroundColor(.secondary)
                    } else {
                        let todayEvents = events.filter { Calendar.current.isDate($0.startDate, inSameDayAs: Date()) }
                        ForEach(todayEvents.prefix(2), id: \.id) { event in
                            EventRow(event: event, isToday: true)
                                .environment(\.colorScheme, colorScheme)
                               
                            
                            
                        }
                    }
                    
                    Spacer()
                }
                
                Spacer()
            }
        }
        .containerBackground(colorScheme == .dark ? Color(.darkdarkBlue).gradient : Color(.white).gradient, for: .widget)
    }
}


struct MediumCalendarWidget: View {
    @State var events: [WidgetEvent]
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            
            HStack {
                
                VStack(alignment: .leading, spacing: 1) {
                    // Day Name
                    Text("\(formatDate(Date(), format: "MMMM"))")
                        .font(Font.custom("Viga-Regular", size: 20))
                        .foregroundStyle(Color(.rorange))
                    
                    
                    // Date Number
                    Text("\(formattedDayWithSuffix(Date()))")
                        .font(Font.custom("Viga-Regular", size: 35))
                        .offset(y: -4)
                    
                    VStack(alignment: .leading) {
                        let todayEvents = events.filter { Calendar.current.isDate($0.startDate, inSameDayAs: Date()) }
                        
                        if !todayEvents.isEmpty {
                            ForEach(todayEvents.prefix(2), id: \.id) { event in
                                EventRow(event: event, isToday: true)
                                    .environment(\.colorScheme, colorScheme)
                            }
                        }
                    }
                    
                }
                .frame(width: 100, height: 130)
                
                Spacer()
                
                Rectangle()
                    .frame(width: 1, height: 125)
                    .foregroundColor(Color(.lightGray))
                    .padding(.leading)
                
                VStack(alignment: .leading, spacing: 3) {
                    
                    
                    // Filter and display upcoming events
                    let upcomingEvents = events.filter {
                        !Calendar.current.isDate($0.startDate, inSameDayAs: Date()) &&
                        $0.startDate > Date()
                    }
                    
                    if upcomingEvents.isEmpty {
                        Text("No upcoming events")
                            .font(.body)
                            .foregroundColor(.secondary)
                    } else {
                        ForEach(upcomingEvents.prefix(4), id: \.id) { event in
                            EventRow(event: event)
                            
                            if event.id != upcomingEvents.prefix(4).last?.id {
                                Divider()
                                    .foregroundStyle(.white)
                            }
                        }
                    }
                }
                .padding()
                .containerBackground(colorScheme == .dark ? Color(.darkdarkBlue).gradient : Color(.white).gradient, for: .widget)
            }
        }
    }
}

struct EventRow: View {
    var event: WidgetEvent
    var isToday: Bool = false
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack {
            // Vertical Bar for Today's Events
            Rectangle()
                .fill(getEventTypeColor(event.eventType))
                .frame(width: 2, height: 20)
                .cornerRadius(1)
            
            VStack(alignment: .leading, spacing: 1) {
                Text(event.title)
                    .font(Font.custom("Viga-Regular", size: 12))
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                
                Text("\(formatDate(event.startDate, format: isToday ? "h:mm a" :"MMM dd h:mm a")) - \(formatDate(event.endDate, format: "h:mm a"))")
                    .font(.system(size: 7))
                    .fontWeight(.semibold)
                    .foregroundColor(colorScheme == .dark ? .gray : .secondary)
            }
        }
        // You can also add background color if needed
        .containerBackground(colorScheme == .dark ? Color(.darkdarkBlue).gradient : Color(.white).gradient, for: .widget)
    }
}

private func formatDate(_ date: Date, format: String) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = format
    return formatter.string(from: date)
}


private func getEventTypeColor(_ eventType: String) -> Color {
    switch eventType {
    case "GBM":
        return .blue
    case "Workshop":
        return .green
    case "Social":
        return .purple
    case "Volunteering":
        return .orange
    case "Info":
        return .yellow
    default:
        return .gray
    }
}

private func formattedDayWithSuffix(_ date: Date) -> String {
    let calendar = Calendar.current
    let day = calendar.component(.day, from: date) // Extracts day number
    
    let suffix: String
    switch day {
    case 11, 12, 13: suffix = "th" // Special case for 11-13
    default:
        switch day % 10 {
        case 1: suffix = "st"
        case 2: suffix = "nd"
        case 3: suffix = "rd"
        default: suffix = "th"
        }
    }
    
    return "\(day)\(suffix)"
}


struct CalendarWidget: Widget {
    
    let kind: String = "CalendarWidget"
    // DataManager instance
    let dataManager = DataManager()
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider(dataManager: dataManager)) { entry in
            CalendarWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Calendar Widget")
        .description("Displays your upcoming events.")
        .supportedFamilies([.systemMedium, .accessoryCircular])
    }
}

// Preview provider for the widget
struct CalendarWidget_Previews: PreviewProvider {
    static var previews: some View {
        CalendarWidgetEntryView(entry: SimpleEntry(
            date: Date(),
            events: [
                WidgetEvent(
                    
                    title: "GBM #1",
                    startDate: Date().addingTimeInterval(1),
                    endDate: Date().addingTimeInterval(3600),
                    eventType: "GBM"
                ),
                WidgetEvent(
                    
                    title: "Career Workshop",
                    startDate: Date().addingTimeInterval(6500),
                    endDate: Date().addingTimeInterval(4),
                    eventType: "Workshop"
                ),
                
                WidgetEvent(
                    
                    title: "GFT Sign Ups Due",
                    startDate: Date().addingTimeInterval(8640005555),
                    endDate: Date().addingTimeInterval(900000),
                    eventType: "Social"
                ),
                
                WidgetEvent(
                    
                    title: "Tabling",
                    startDate: Date().addingTimeInterval(864000),
                    endDate: Date().addingTimeInterval(900000),
                    eventType: "Volunteering"
                )
                
            ]
        ))
        .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}

// Widget bundle

struct CalendarWidgets: WidgetBundle {
    var body: some Widget {
        CalendarWidget()
    }
}

