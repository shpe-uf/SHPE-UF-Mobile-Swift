
import Foundation


class SHPEito
{
    // Initializer
    init(username: String, password: String, remember: String, photo:String = "", firstName:String, lastName:String,year:String, major:String,id:String,token:String,confirmed:Bool,updatedAt:String, createdAt:String, email:String, fallPoints:Int,summerPoints:Int,springPoints:Int)
    {
        self.username = username
        self.password = password
        self.remember = remember
        self.photoURL = URL(string: photo)
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
        //self.events = events
        
    }
    
    init ()
    {
        self.username = ""
        self.password = ""
        self.remember = ""
        self.photoURL = nil
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
    }
    
    @Published var username: String
    @Published var password: String
    @Published var remember: String
    @Published var photoURL: URL?
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
    @Published var fallPoints: Int
    @Published var springPoints: Int
    @Published var summerPoints: Int
    //@Published var events: SHPESchema.SignInMutation
    // Any methods that can help with
}
