//
//  SHPEUFAppViewModel.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by Daniel Parra on 3/9/24.
//

import Foundation
import SwiftUI

class AppViewModel: ObservableObject
{
    static let appVM = AppViewModel()
    @Published var pageIndex:Int
    @Published var shpeito:SHPEito
    @Published var darkMode:Bool
    
    private init() {
        self.pageIndex = -1
        self.shpeito = SHPEito()
        self.darkMode = false
    }
    
    public func setPageIndex(index:Int)
    {
        self.pageIndex = index
    }
    
    public func setDarkMode(bool:Bool, user: FetchedResults<User>)
    {
        self.darkMode = bool
        if !user.isEmpty
        {
            user[0].darkMode = bool
        }
    }
}
