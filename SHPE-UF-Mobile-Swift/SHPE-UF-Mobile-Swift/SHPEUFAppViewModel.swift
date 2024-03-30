//
//  SHPEUFAppViewModel.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by Daniel Parra on 3/9/24.
//

import Foundation
import SwiftUI
import CoreData

class AppViewModel: ObservableObject
{
    static let appVM = AppViewModel()
    @Published var pageIndex:Int
    @Published var shpeito:SHPEito
    @Published var darkMode:Bool
    @Published var showToast:Bool
    @Published var toastMessage:String
    
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
            do { try viewContext.save() } catch { print("Could not save to Core") }
        }
    }
}
