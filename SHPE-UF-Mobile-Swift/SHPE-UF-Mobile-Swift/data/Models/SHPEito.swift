import Foundation

class SHPEito {
    // Initializers
    init(firstName: String, lastName: String, photo: String, major: String, year: String, graduating: String, country: String, ethnicity: String, sex: String, username: String, email: String, password: String, createdAt: String, updatedAt: String, points: Int, fallPoints: Int, springPoints: Int, summerPoints: Int, fallPercentile: Int, springPercentile: Int, summerPercentile: Int, permission: String, listServ: Bool, internships: [String], socialMedia: [String], events: [Event], tasks: [Task], bookmarkedTasks: [String], classes: [String], token: String?, confirmed: Bool, bookmarks: [String]) {
            self.firstName = firstName
            self.lastName = lastName
            self.photo = photo
            self.major = major
            self.year = year
            self.graduating = graduating
            self.country = country
            self.ethnicity = ethnicity
            self.sex = sex
            self.username = username
            self.email = email
            self.password = password
            self.createdAt = createdAt
            self.updatedAt = updatedAt
            self.points = points
            self.fallPoints = fallPoints
            self.springPoints = springPoints
            self.summerPoints = summerPoints
            self.fallPercentile = fallPercentile
            self.springPercentile = springPercentile
            self.summerPercentile = summerPercentile
            self.permission = permission
            self.listServ = listServ
            self.internships = internships
            self.socialMedia = socialMedia
            self.events = events
            self.tasks = tasks
            self.bookmarkedTasks = bookmarkedTasks
            self.classes = classes
            self.token = token
            self.confirmed = confirmed
            self.bookmarks = bookmarks
        }
    
    // Attributes
        @Published var firstName: String
        @Published var lastName: String
        @Published var photo: String
        @Published var major: String
        @Published var year: String
        @Published var graduating: String
        @Published var country: String
        @Published var ethnicity: String
        @Published var sex: String
        @Published var username: String
        @Published var email: String
        @Published var password: String
        @Published var createdAt: String
        @Published var updatedAt: String
        @Published var points: Int
        @Published var fallPoints: Int
        @Published var springPoints: Int
        @Published var summerPoints: Int
        @Published var fallPercentile: Int
        @Published var springPercentile: Int
        @Published var summerPercentile: Int
        @Published var permission: String
        @Published var listServ: Bool
        @Published var internships: [String]
        @Published var socialMedia: [String]
        @Published var events: [Event]
        @Published var tasks: [Task]
        @Published var bookmarkedTasks: [String]
        @Published var classes: [String]
        @Published var token: String?
        @Published var confirmed: Bool
        @Published var bookmarks: [String]
    }

    // nested types representing an event associated with a user
    struct Event {
        let name: String
        let category: String
        let createdAt: String
        let points: Int
    }
    // nested type representing a task associated with a user
    struct Task {
        let name: String
        let startDate: String
        let points: Int
    }
