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
                self.attemptMigration()
            }
            
            self.container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        }
    }
    
    private func attemptMigration() {
        let persistentStoreCoordinator = container.persistentStoreCoordinator
        let storeURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("CoreUserModel.sqlite")

        
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
            print("Migration successful")
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
