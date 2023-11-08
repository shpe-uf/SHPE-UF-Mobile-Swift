
import Foundation


class SHPEito: Identifiable {
    var id:UUID = UUID()
    var firstName: String = ""
    var lastName: String = ""
    var photo: String = ""
    var major: String = ""
    var year: String = ""
    var graduating: String = ""
    var country: String = ""
    var ethnicity: String = ""
    var sex: String = ""
    var username: String = ""
    var email: String = ""
    private var password: String = ""
    var createdAt: Date = Date()
    var updatedAt: Date = Date()
    var points: Int = 0
    var fallPoints: Int = 0
    var springPoints: Int = 0
    var summerPoints: Int = 0
    var fallPercentile: Int = 0
    var springPercentile: Int = 0
    var summerPercentile: Int = 0
    var permission: String = ""
    var listServ: Bool = false
    var internships: [String] = []
    var socialMedia: [String] = []
//    var events: [Event]
//    var tasks: [Task]
    var bookmarkedTasks: [String] = []
    var classes: [String] = []
    var token: String = ""
    var confirmed: Bool = false
    var bookmarks: [String] = []
}
