import Foundation
import SwiftUI

class SHPEito
{
    init(username: String, password: String, remember: String, photo:String = "", firstName:String, lastName:String,year:String, major:String,id:String,token:String,confirmed:Bool,updatedAt:String, createdAt:String, email:String, fallPoints:Int,summerPoints:Int,springPoints:Int, points: Int = 0, fallPercentile: Int = 0, springPercentile: Int = 0, summerPercentile: Int = 0)
    {
        self.username = username
        self.password = password
        self.remember = remember
        self.photoURL = URL(string: photo)
        self.name = firstName + " " + lastName
        self.firstName = firstName
        self.lastName = lastName
        self.year = year
        self.major = major
        self.id = id
        self.token = token
        self.confirmed = confirmed
        self.updatedAt = updatedAt
        self.createdAt = createdAt
        self.email = email
        self.fallPoints = fallPoints
        self.summerPoints = summerPoints
        self.springPoints = springPoints
        self.points = points
        self.fallPercentile = fallPercentile
        self.springPercentile = springPercentile
        self.summerPercentile = summerPercentile
        //self.events = events 
    }
    
    init ()
    {
        self.username = ""
        self.password = ""
        self.remember = ""
        self.photoURL = nil
        self.name = ""
        self.firstName = ""
        self.lastName = ""
        self.year = ""
        self.major = ""
        self.id = ""
        self.token = ""
        self.confirmed = false
        self.updatedAt = ""
        self.createdAt = ""
        self.email = ""
        self.fallPoints = -1
        self.summerPoints = -1
        self.springPoints = -1
        self.points = 0
        self.fallPercentile = 0
        self.springPercentile = 0
        self.summerPercentile = 0
    }
    
    @Published var username: String
    @Published var password: String
    @Published var remember: String
    @Published var photoURL: URL?
    @Published var name:String
    @Published var firstName:String
    @Published var lastName:String
    @Published var year: String
    @Published var major: String
    @Published var id: String
    @Published var token: String
    @Published var confirmed: Bool
    @Published var updatedAt: String
    @Published var createdAt: String
    @Published var email: String
    @Published var points: Int
    @Published var fallPoints: Int
    @Published var springPoints: Int
    @Published var summerPoints: Int
    @Published var fallPercentile : Int
    @Published var springPercentile : Int
    @Published var summerPercentile : Int
    @Published var profileImage: UIImage?
    //@Published var events: SHPESchema.SignInMutation
    // Any methods that can help with
    
    //TODO: GET THESE ATTRIBUTES WHEN FETCHING USER
    @Published var gender:String = "Male"
    @Published var ethnicity:String = "Hispanic"
    @Published var originCountry:String = "Cuba"
    @Published var graduationYear:String = "2026"
    @Published var classes:[String] = ["Data Structures", "Discrete Structures", "Calculus 3"]
    @Published var internships:[String] = ["Microsoft", "Apple", "Google"]
    @Published var links:[URL] = [URL(string: "https://www.linkedin.com/in/david-denis-/")!]
    
    func loadProfileImage()
    {
        if let url = self.photoURL,
           self.profileImage == nil
        {
            URLSession.shared.dataTask(with: url) 
            { [weak self] (data, response, error) in
                guard let self = self else { return }

                // Check for errors
                if let error = error {
                    print("Error loading image: \(error)")
                    return
                }

                // Check if the response contains valid image data
                guard let data = data, let image = UIImage(data: data) else {
                    print("Invalid image data")
                    return
                }

                // Update the UI on the main queue
                DispatchQueue.main.async {
                    self.profileImage = image
                }
            }.resume()
        }
    }
}
