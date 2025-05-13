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
        
        // Configure the container to use the App Group shared container for the Widget Extension
        if let storeURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.widgets-shared")?.appendingPathComponent("CoreUserModel.sqlite") {
            let storeDescription = NSPersistentStoreDescription(url: storeURL)
            container.persistentStoreDescriptions = [storeDescription]
            print("Using shared App Group store at: \(storeURL)")
        }
        
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error {
                self.attemptMigration()
            }
            
            self.container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        }
    }
    
    // updated to use shared container for widget
    private func attemptMigration() {
        let persistentStoreCoordinator = container.persistentStoreCoordinator
        
        guard let storeURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.widgets-shared")?.appendingPathComponent("CoreUserModel.sqlite") else {
                   print("Failed to get App Group container URL")
                   return
               }
        
        let migrationOptions: [AnyHashable: Any] = [
            NSMigratePersistentStoresAutomaticallyOption: true,
            NSInferMappingModelAutomaticallyOption: true
        ]
        
        do {
            try persistentStoreCoordinator.addPersistentStore(
                ofType: NSSQLiteStoreType,
                configurationName: nil,
                at: storeURL,
                options: migrationOptions
            )
        } catch {
            print("Migration failed, clearing core of models: \(error)")
            self.clearCoreData()
        }
    }
    
    private func clearCoreData() {
        let context = container.viewContext

        // Fetch all entities
        let entityNames = container.managedObjectModel.entities.compactMap { $0.name }

        for entityName in entityNames {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

            do {
                try context.execute(deleteRequest)
                try context.save()
                print("Cleared Core Data for entity \(entityName)")
            } catch {
                print("Failed to clear Core Data for entity \(entityName): \(error)")
            }
        }
    }
}
