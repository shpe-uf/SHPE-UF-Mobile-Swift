import CoreData
import Foundation

/// Main data manager to handle the todo items
class DataManager: NSObject, ObservableObject {
    /// Dynamic properties that the UI will react to
    @Published var shpeito: User = User()
    
    /// Add the Core Data container with the model name
    let container: NSPersistentContainer
    
    /// Managed object context connected to the persistent store coordinator
    var managedObjectContext: NSManagedObjectContext {
        container.viewContext
    }
    
    /// Default init method. Load the Core Data container
    override init() {
        container = NSPersistentContainer(name: "CoreUserModel")
        super.init()
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
    }
}
