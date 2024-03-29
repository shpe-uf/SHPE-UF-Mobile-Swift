import Foundation
import SwiftUI

class SHPEito
{
    init(
        username: String, password: String, remember: String, base64StringPhoto:String = "", firstName:String, lastName:String,year:String, major:String,id:String,token:String,confirmed:Bool,updatedAt:String, createdAt:String, email:String,
        
        gender:String, ethnicity:String, originCountry:String, graduationYear:String, classes:[String], internships:[String], links:[String],
         
         fallPoints:Int,summerPoints:Int,springPoints:Int, points: Int, fallPercentile: Int, springPercentile: Int, summerPercentile: Int)
    {
        self.username = username
        self.password = password
        self.remember = remember
        
        if let imageData = Data(base64Encoded: base64StringPhoto, options: .ignoreUnknownCharacters),
           let image = UIImage(data: imageData)
        {
            self.profileImage = image
        }
        
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
        
        self.gender = gender
        self.ethnicity = ethnicity
        self.originCountry = originCountry
        self.graduationYear = graduationYear
        self.classes = classes
        self.internships = internships
        self.links = {
            var linkArray:[URL] = []
            for link in links {
                if let url = URL(string:link)
                {
                    linkArray.append(url)
                }
            }
            return linkArray
        }()
        
        
        
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
        self.gender = ""
        self.ethnicity = ""
        self.originCountry = ""
        self.graduationYear = ""
        self.classes = []
        self.internships = []
        self.links = []
    }
    
    @Published var username: String
    @Published var password: String
    @Published var remember: String
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
    @Published var gender:String
    @Published var ethnicity:String
    @Published var originCountry:String
    @Published var graduationYear:String
    @Published var classes:[String]
    @Published var internships:[String]
    @Published var links:[URL]
    
    func setLinks(links:[String])
    {
        for link in links
        {
            if let url = URL(string: link),
               !self.links.contains(url)
            {
                self.links.append(url)
            }
        }
    }
    
    func absoluteStringsOfLinks()->[String]
    {
        var stringArray:[String] = []
        
        for link in self.links
        {
            stringArray.append(link.absoluteString)
        }
        return stringArray
    }
}
