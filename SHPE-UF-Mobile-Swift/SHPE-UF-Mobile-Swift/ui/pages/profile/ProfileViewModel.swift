//
//  ProfileViewModel.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by Daniel Parra on 3/26/24.
//

import Foundation

class ProfileViewModel:ObservableObject
{
    init (shpeito: SHPEito)
    {
        self.shpeito = shpeito
    }
    
    @Published var shpeito:SHPEito
    @Published var isEditing = false
    
    var gender = 0
    let genderoptions = ["Male", "Female", "Non-Binary"]
    var ehtnicity = 0
    let ethnicityoptions = ["Hispanic", "African American", "White", "Asian", "Native American/Alaskan Native", "Native Hawaiian/Pacific Islander", "Middle Eastern/North African", "Multiethnic"]
    var origin = 0
    let originoptions = ["x", "x", "z"]
    var year = 0
    let yearoptions = ["Freshman", "Sophomore", "Junior", "Senior", "5th Year"]
    var grad = 0
    let gradoptions = ["2024", "2025", "2026", "2027", "2028"]

    var enteredClasses: String = ""
    var selectedClasses: [String] = []

    var enteredInternships: String = ""
    var selectedInternships: [String] = []
}
