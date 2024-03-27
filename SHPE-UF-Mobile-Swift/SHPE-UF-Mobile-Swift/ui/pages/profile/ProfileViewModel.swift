//
//  ProfileViewModel.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by Daniel Parra on 3/26/24.
//

import Foundation
import UIKit

class ProfileViewModel:ObservableObject
{
    init (shpeito: SHPEito)
    {
        self.shpeito = shpeito
        self.newName = shpeito.name
        self.newUsername = shpeito.username
        self.newGender = shpeito.gender
        self.newEthnicity = shpeito.ethnicity
        self.newOriginCountry = shpeito.originCountry
        self.newYear = shpeito.year
        self.newGradYear = shpeito.graduationYear
        self.newClasses = shpeito.classes
        self.newInternships = shpeito.internships
        self.newLinks = shpeito.links.map({ url in
            url.absoluteString
        })
        self.showImagePicker = false
        self.selectedImage = shpeito.profileImage
        
        // Get the current year
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: Date())

        // Generate a list with the current year and the next four years as strings
        var yearsList: [String] = []
        for i in 0..<5 {
            let year = String(currentYear + i)
            yearsList.append(year)
        }
        
        self.gradoptions = yearsList
    }
    
    @Published var shpeito:SHPEito
    @Published var isEditing = false
    
    @Published var newName:String
    @Published var newUsername:String
    @Published var newGender:String
    @Published var newEthnicity:String
    @Published var newOriginCountry:String
    @Published var newYear:String
    @Published var newGradYear:String
    @Published var newClasses:[String]
    @Published var newInternships:[String]
    @Published var newLinks:[String]
    
    @Published var showImagePicker: Bool
    @Published var selectedImage: UIImage?
    
    var gender = 0
    let genderoptions = ["Male", "Female", "Non-Binary"]
    var ehtnicity = 0
    let ethnicityoptions = ["Hispanic", "African American", "White", "Asian", "Native American/Alaskan Native", "Native Hawaiian/Pacific Islander", "Middle Eastern/North African", "Multiethnic"]
    var origin = 0
    let originoptions = ["x", "x", "z"]
    var year = 0
    let yearoptions = ["Freshman", "Sophomore", "Junior", "Senior", "5th Year"]
    var grad = 0
    
    var gradoptions:[String] = []

    var enteredClasses: String = ""
    var selectedClasses: [String] = []

    var enteredInternships: String = ""
    var selectedInternships: [String] = []
    
    func clearFields()
    {
        let shpeito = self.shpeito
        self.shpeito = shpeito
        self.newName = shpeito.name
        self.newUsername = shpeito.username
        self.newGender = shpeito.gender
        self.newEthnicity = shpeito.ethnicity
        self.newOriginCountry = shpeito.originCountry
        self.newYear = shpeito.year
        self.newGradYear = shpeito.graduationYear
        self.newClasses = shpeito.classes
        self.newInternships = shpeito.internships
        self.newLinks = shpeito.links.map({ URL in
            URL.absoluteString
        })
        self.showImagePicker = false
        self.selectedImage = shpeito.profileImage
    }
}
