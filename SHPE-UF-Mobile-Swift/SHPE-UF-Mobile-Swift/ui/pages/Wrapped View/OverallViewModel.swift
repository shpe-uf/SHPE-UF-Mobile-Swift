//
//  YearsViewModel.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by Alex Milanes on 10/2/25.
//


import SwiftUI

class OverallViewModel: ObservableObject {
    @Published var shpeito: SHPEito
    
    
    init(shpeito: SHPEito) {
        self.shpeito = shpeito
    }
}
