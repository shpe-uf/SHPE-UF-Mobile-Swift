//
//  EventBox.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by Matthew Segura on 12/20/24.
//
import SwiftUI
import CoreData

/// A container view that displays either a timed or all-day event with appropriate styling.
///
/// This view:
/// 1. Automatically determines whether to show time information
/// 2. Applies consistent styling based on event type
/// 3. Handles animations for ongoing events
/// 4. Adapts to light/dark mode
///
/// ## Behavior
/// - Shows `EventWithTimeView` when start/end times differ
/// - Shows `EventNoTimeView` for all-day events (same start/end time)
/// - Animates border for currently ongoing events
///
/// ## Example Usage
/// ```swift
/// EventBox(event: conferenceEvent)
/// ```
struct EventBox: View {
    var event: Event
    @Environment(\.colorScheme) var colorScheme
    @State private var isAnimating = false
    @State private var ongoing = false
    
    var body: some View {
        let dateHelper = DateHelper()
        let startTimeString = dateHelper.getTime(for: event.start.dateTime)
        let endTimeString = dateHelper.getTime(for: event.end.dateTime)
        let startDateString = dateHelper.getDayFull(for: event.start.dateTime)
        let (color, iconImage) = eventTypeVariables(event: event)
        
        Group {
            if startTimeString == endTimeString {
                EventNoTimeView(
                    event: event,
                    color: color,
                    iconImage: iconImage,
                    startDateString: startDateString,
                    isAnimating: $isAnimating,
                    ongoing: $ongoing
                )
            } else {
                EventWithTimeView(
                    event: event,
                    color: color,
                    iconImage: iconImage,
                    startDateString: startDateString,
                    startTimeString: startTimeString,
                    endTimeString: endTimeString,
                    isAnimating: $isAnimating,
                    ongoing: $ongoing
                )
            }
        }
    }

    /// Returns the display properties (color and icon) for a given event type.
    ///
    /// This function:
    /// 1. Matches event types to their corresponding UI properties
    /// 2. Provides consistent styling across the application
    /// 3. Includes a default case for unknown event types
    ///
    /// - Parameter event: The event to get display properties for
    /// - Returns: A tuple containing (color, iconName) for the event type
    ///
    /// ## Event Type Mapping
    /// - "GBM" → (Constants.grey, "Business_Group")
    /// - "Workshop" → (Constants.orange, "Training")
    /// - "Social" → (Constants.blue, "Users")
    /// - "Volunteering" → (Constants.green, "Volunteering")
    /// - "Info" → (Constants.teal, "Info")
    /// - default → (.clear, "Business_Group")
    ///
    /// ## Example Usage
    /// ```swift
    /// let (color, icon) = eventTypeVariables(event: workshopEvent)
    /// ```
    func eventTypeVariables(event: Event) -> (Color, String) {
        switch event.eventType {
        case "GBM":
            return (Constants.grey, "Business_Group")
        case "Workshop":
            return (Constants.orange, "Training")
        case "Social":
            return (Constants.blue, "Users")
        case "Volunteering":
            return (Constants.green, "Volunteering")
        case "Info":
            return (Constants.teal, "Info")
        default:
            return (.clear, "Business_Group")
        }
    }
}

/// A view component that displays an all-day event without specific time information.
///
/// This view:
/// 1. Shows event title and date
/// 2. Provides visual feedback for ongoing events
/// 3. Includes an icon representing the event type
/// 4. Adapts its appearance based on event state
///
/// ## Visual Features
/// - Colored background based on event type
/// - Animated border for ongoing events
/// - Date information with calendar icon
/// - Event type icon
///
/// ## Example Usage
/// ```swift
/// EventNoTimeView(
///     event: conferenceEvent,
///     color: .blue,
///     iconImage: "conference-icon",
///     startDateString: "Jun 15",
///     isAnimating: $isAnimating,
///     ongoing: $isOngoing
/// )
/// ```
struct EventNoTimeView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var event: Event
    var color: Color
    var iconImage: String
    var startDateString: String
    @Binding var isAnimating: Bool
    @Binding var ongoing: Bool
    
    var body: some View {
        ZStack {
            if #available(iOS 26.0, *) {
                HStack {
                    VStack(alignment: .leading) {
                        Text(event.summary)
                            .font(.headline)
                            .lineLimit(1)
                    }
                    
                    Spacer()
                    
                    Image(iconImage)
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundStyle(colorScheme == .dark ? .white : .black)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .glassEffect(.regular.tint(color.opacity(0.4)).interactive(),
                             in: RoundedRectangle(cornerRadius: 25))

                // subtle pulse without changing layout
                .shadow(color: color.opacity(isAnimating ? 0.6 : 0.2),
                        radius: isAnimating ? 10 : 4)
                .animation(
                    .easeInOut(duration: 1.5).repeatForever(autoreverses: true),
                    value: isAnimating
                )
                
            } else {
                // Fallback on earlier versions
                HStack {
                    VStack(alignment: .leading) {
                        Text(event.summary)
                            .font(.headline)
                            .lineLimit(1)
                    }
                    
                    Spacer()
                    
                    Image(iconImage)
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundStyle(colorScheme == .dark ? .white : .black)
                }
                .frame(maxWidth: .infinity)
                .padding()

                // subtle pulse without changing layout
                .shadow(color: color.opacity(isAnimating ? 0.6 : 0.2),
                        radius: isAnimating ? 10 : 4)
                .animation(
                    .easeInOut(duration: 1.5).repeatForever(autoreverses: true),
                    value: isAnimating
                )
            }
        }
        .onAppear {
            self.ongoing = event.start.dateTime <= Date() && event.end.dateTime >= Date()
            self.isAnimating = ongoing
        }
    }
}

/// A view component that displays an event with its time information and visual indicators.
///
/// This view:
/// 1. Shows event details (title, date, time range)
/// 2. Provides visual feedback for ongoing events
/// 3. Includes an icon representing the event type
/// 4. Adapts its appearance based on event state
///
/// ## Visual Features
/// - Colored background based on event type
/// - Animated border for ongoing events
/// - Date/time information with icons
/// - Event type icon
///
/// ## Example Usage
/// ```swift
/// EventWithTimeView(
///     event: conferenceEvent,
///     color: .blue,
///     iconImage: "conference-icon",
///     startDateString: "Jun 15",
///     startTimeString: "09:00",
///     endTimeString: "17:00",
///     isAnimating: $isAnimating,
///     ongoing: $isOngoing
/// )
/// ```
struct EventWithTimeView: View {
    @Environment(\.colorScheme) var colorScheme

    var event: Event
    var color: Color
    var iconImage: String
    var startDateString: String
    var startTimeString: String
    var endTimeString: String
    @Binding var isAnimating: Bool
    @Binding var ongoing: Bool
    
    var body: some View {
        //Prints out events with set times
        ZStack{
            if #available(iOS 26.0, *) {
                HStack {
                    VStack(alignment: .leading) {
                        Text(event.summary)
                            .font(.headline)
                            .lineLimit(1)
                        
                        HStack {
                            Image(systemName: "clock")
                                .font(.caption)
                            
                            Text("\(startTimeString) - \(endTimeString)")
                                .font(.caption)
                        }
                    }
                    
                    Spacer()
                    
                    Image(iconImage)
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundStyle(colorScheme == .dark ? .white : .black)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .glassEffect(.regular.tint(color.opacity(0.4)).interactive(),
                             in: RoundedRectangle(cornerRadius: 25))

                // subtle pulse without changing layout
                .shadow(color: color.opacity(isAnimating ? 0.6 : 0.2),
                        radius: isAnimating ? 10 : 4)
                .animation(
                    .easeInOut(duration: 1.5).repeatForever(autoreverses: true),
                    value: isAnimating
                )
                
            } else {
                // Fallback on earlier versions
                HStack {
                    VStack(alignment: .leading) {
                        Text(event.summary)
                            .font(.headline)
                            .lineLimit(1)
                        
                        HStack {
                            Image(systemName: "clock")
                                .font(.caption)
                            
                            Text("\(startTimeString) - \(endTimeString)")
                                .font(.caption)
                        }
                    }
                    
                    Spacer()
                    
                    Image(iconImage)
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundStyle(colorScheme == .dark ? .white : .black)
                }
                .frame(maxWidth: .infinity)
                .padding()
                // subtle pulse without changing layout
                .shadow(color: color.opacity(isAnimating ? 0.6 : 0.2),
                        radius: isAnimating ? 10 : 4)
                .animation(
                    .easeInOut(duration: 1.5).repeatForever(autoreverses: true),
                    value: isAnimating
                )
            }
        }
        .onAppear {
            self.ongoing = event.start.dateTime <= Date() && event.end.dateTime >= Date()
            self.isAnimating = ongoing
        }
    }
}

//#Preview {
//    EventBox(event: Event.mock)
//        .preferredColorScheme(ColorScheme.dark)
//}
