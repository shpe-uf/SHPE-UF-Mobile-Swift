
import Foundation


class SHPEito 
{
    // Initializer
    init(id:String, name: String, points: Int, fallPercentile: Int, springPercentile: Int, summerPercentile: Int, fallPoints: Int, springPoints: Int, summerPoints: Int, username: String)
    {
        self.id = id
        self.name = name
        self.points = points
        self.fallPercentile = fallPercentile
        self.springPercentile = springPercentile
        self.summerPercentile = summerPercentile
        self.fallPoints = fallPoints
        self.springPoints = springPoints
        self.summerPoints = summerPoints
        self.username = username

        
    }
    
    // Attributes
    let id:String
    @Published var name : String
    @Published var points : Int
    @Published var fallPercentile : Int
    @Published var springPercentile : Int
    @Published var summerPercentile : Int
    
    @Published var fallPoints : Int
    @Published var springPoints : Int
    @Published var summerPoints : Int

    @Published var username: String
    
    // Any methods that can help with 
    // representing the data...
}
