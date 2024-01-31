
import Foundation


class SHPEito 
{
    // Initializer
    init(id:String, name: String, points: Int) 
    {
        self.id = id
        self.name = name
        self.points = points
    }
    
    // Attributes
    let id:String
    @Published var name:String
    @Published var points:Int
    
    // Any methods that can help with 
    // representing the data...
}
