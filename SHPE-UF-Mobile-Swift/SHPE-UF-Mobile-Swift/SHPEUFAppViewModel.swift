//
//  SHPEUFAppViewModel.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by Daniel Parra on 3/9/24.
//

import Foundation
import SwiftUI
import CoreData

/// A centralized view model that manages application state and user preferences.
///
/// This singleton class serves as the main state container for the application, handling:
/// - UI navigation and view management
/// - User preferences (dark mode)
/// - Toast notifications
/// - Map-related data
///
/// ## Overview
/// The `AppViewModel` follows the singleton pattern to ensure consistent state across the app.
/// It's designed to be used as an `@ObservedObject` or `@StateObject` in SwiftUI views.
///
/// ## Key Responsibilities
/// - Managing the current view hierarchy
/// - Storing and persisting user preferences
/// - Displaying toast messages
/// - Coordinating map interactions
///
/// ## Example Usage
/// ```swift
/// @StateObject private var appVM = AppViewModel.appVM
/// ```
class AppViewModel: ObservableObject
{
    static let appVM = AppViewModel()
    @Published var pageIndex:Int
    @Published var shpeito:SHPEito
    @Published var darkMode:Bool
    @Published var showToast:Bool
    @Published var toastMessage:String
    
    // Items being observed in the home view
    @Published var showView = "HomeView"
    @Published var currentEventIndex:Int?
    @Published var inMapView = false
    
    // Items being observed by the map
    @Published var placemark:MTPlacemark?
    
    private init() {
        self.pageIndex = -1
        self.shpeito = SHPEito()
        self.darkMode = false
        self.showToast = false
        self.toastMessage = ""
    }
    
    public func setPageIndex(index:Int)
    {
        self.pageIndex = index
    }
    
    public func setDarkMode(bool:Bool, user: FetchedResults<User>, viewContext:NSManagedObjectContext)
    {
        self.darkMode = bool
        if !user.isEmpty
        {
            user[0].darkMode = bool
            do { try viewContext.save() } catch { print("Could not set dark mode to User in Core") }
        }
    }
}
