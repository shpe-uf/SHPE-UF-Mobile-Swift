//
//  ProfileViewModel.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by Daniel Parra on 3/26/24.
//

import Foundation
import UIKit
import CoreData
import SwiftUI

enum Loading
{
    case NotLoading
    case Loading
    case Success
    case Failure
}

class ProfileViewModel:ObservableObject
{
    private var requestHandler = RequestHandler()
    private var auth:SignInViewModel
    
    init (shpeito: SHPEito)
    {
        self.shpeito = shpeito
        self.newName = shpeito.name
        self.newUsername = shpeito.username
        self.newGender = shpeito.gender
        self.newEthnicity = shpeito.ethnicity
        self.newOriginCountry = shpeito.originCountry
        self.newMajor = shpeito.major
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
        self.auth = SignInViewModel(shpeito: shpeito)
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
    @Published var newMajor:String
    @Published var newClasses:[String]
    @Published var newInternships:[String]
    @Published var newLinks:[String]
        
    @Published var showImagePicker: Bool
    @Published var selectedImage: UIImage?
    
    @Published var loadingStatus:Loading = .NotLoading
    
    @Published var invalidFirstName:Bool = false
    @Published var invalidLastName:Bool = false
    @Published var invalidUsername:Bool = false
    
    let majorOptions =
    [
        "Aerospace Engineering",
        "Agricultural & Biological Engineering",
        "Biomedical Engineering",
        "Chemical Engineering",
        "Civil Engineering",
        "Coastal & Oceanographic Engineering",
        "Computer Engineering",
        "Computer Science",
        "Digital Arts & Sciences",
        "Electrical Engineering",
        "Environmental Engineering Sciences",
        "Human-Centered Computing",
        "Industrial & Systems Engineering",
        "Materials Science & Engineering",
        "Mechanical Engineering",
        "Nuclear Engineering",
        "Other"
    ]
    
    var gender = 0
    let genderoptions = [
        "Male",
        "Female",
        "Non-Binary",
        "Other",
        "Prefer not to answer"
    ]
    var ehtnicity = 0
    let ethnicityoptions = [
        "American Indian or Alaska Native",
        "Asian",
        "Black or African American",
        "Hispanic/Latino",
        "Native Hawaiian or Other Pacific Islander",
        "White",
        "Two or more ethnicities",
        "Prefer not to answer"
    ]
    var origin = 0
    let originoptions = Locale.countryNames
    var year = 0
    let yearoptions = ["Freshman", "Sophomore", "Junior", "Senior", "5th Year", "Graduate", "Ph.D."]
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
    
    func saveEditsToProfile(user:FetchedResults<User>, viewContext: NSManagedObjectContext)
    {
        self.loadingStatus = .Loading
        
        if let range = newName.range(of: "\\s+", options: .regularExpression) {
            let firstName = newName[..<range.lowerBound]
            let lastName = newName[range.upperBound...].trimmingCharacters(in: .whitespaces)
            if lastName.isEmpty {self.loadingStatus = .Failure; self.invalidLastName=true; return}
            
            print(String(firstName))
            let cond1 = validateFirstName(input: String(firstName))
            let cond2 = validateLastName(input: lastName)
            let cond3 = validateUsername(input: newUsername)
                              
            if !cond1 || !cond2 || !cond3
            {
                self.loadingStatus = .Failure
                return
            }
            
            requestHandler.postEditsToProfile(firstName: String(firstName), lastName: lastName, classes: newClasses, country: newOriginCountry, ethnicity: newEthnicity, graduationYear: newGradYear, internships: newInternships, major: newMajor, photo: selectedImage?.jpegData(compressionQuality: 0.0)?.base64EncodedString() ?? shpeito.profileImage?.jpegData(compressionQuality: 0.0)?.base64EncodedString() ??  "", gender: newGender, links: newLinks, year: newYear, email: shpeito.email)
            { [self] messageDict in
                if (messageDict["success"] != nil)
                {
                    self.shpeito.name = newName
                    self.shpeito.username = newUsername
                    self.shpeito.firstName = String(firstName)
                    self.shpeito.lastName = lastName
                    self.shpeito.classes = newClasses
                    self.shpeito.major = newMajor
                    self.shpeito.originCountry = newOriginCountry
                    self.shpeito.ethnicity = newEthnicity
                    self.shpeito.graduationYear = newGradYear
                    self.shpeito.internships = newInternships
                    self.shpeito.profileImage = self.selectedImage
                    self.shpeito.gender = newGender
                    self.shpeito.links = {
                        var newURLs:[URL] = []
                        for link in newLinks
                        {
                            if let url = URL(string:link)
                            {
                                newURLs.append(url)
                            }
                        }
                        return newURLs
                    }()
                    self.shpeito.year = newYear
                    self.invalidUsername = false
                    self.invalidFirstName = false
                    self.invalidLastName = false
                    CoreFunctions().editUserInCore(users: user, viewContext: viewContext, shpeito: self.shpeito)
                    self.loadingStatus = .Success
                }
                else
                {
                    self.loadingStatus = .Failure
                }
                isEditing = false
            }
            
        } else {
            self.invalidFirstName = true
            self.invalidLastName = true
            validateUsername(input: newUsername)
            self.loadingStatus = .Failure
        }
    }
    
    //validate firstname
    func validateFirstName(input:String) -> Bool
    {
        let namePattern = "^[A-Za-z]{3,20}$"
        let namePredicate = NSPredicate(format:"SELF MATCHES %@", namePattern)
        invalidFirstName = namePredicate.evaluate(with: input)
        return namePredicate.evaluate(with: input)
    }

    //validate lastname
    func validateLastName(input:String) -> Bool
    {
        let namePattern = "^[A-Za-z]{3,20}$"
        let namePredicate = NSPredicate(format:"SELF MATCHES %@", namePattern)
        invalidLastName = namePredicate.evaluate(with: input)
        return namePredicate.evaluate(with: input)
    }
    
    //validate username
    func validateUsername(input:String) -> Bool
    {
        let usernamePattern = "^[\\w.]{6,20}$"
        let usernamePredicate = NSPredicate(format:"SELF MATCHES %@", usernamePattern)
        invalidUsername = usernamePredicate.evaluate(with: input)
        return usernamePredicate.evaluate(with: input)
    }
}
