
import Foundation
import RealmSwift


class SHPEito: Identifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var firstName: String = ""
    @Persisted var lastName: String = ""
    @Persisted var photo: String = ""
    @Persisted var major: String = ""
    @Persisted var year: String = ""
    @Persisted var graduating: String = ""
    @Persisted var country: String = ""
    @Persisted var ethnicity: String = ""
    @Persisted var sex: String = ""
    @Persisted var username: String = ""
    @Persisted var email: String = ""
    @Persisted private var password: String = ""
    @Persisted var createdAt: Date = Date()
    @Persisted var updatedAt: Date = Date()
    @Persisted var points: Int = 0
    @Persisted var fallPoints: Int = 0
    @Persisted var springPoints: Int = 0
    @Persisted var summerPoints: Int = 0
    @Persisted var fallPercentile: Int = 0
    @Persisted var springPercentile: Int = 0
    @Persisted var summerPercentile: Int = 0
    @Persisted var permission: String = ""
    @Persisted var listServ: Bool = false
    @Persisted var internships: List<String>
    @Persisted var socialMedia: List<String>
//  @Persisted   var events: [Event]
//  @Persisted   var tasks: [Task]
    @Persisted var bookmarkedTasks: List<String>
    @Persisted var classes: List<String>
    @Persisted var token: String = ""
    @Persisted var confirmed: Bool = false
    @Persisted var bookmarks: List<String>
}
