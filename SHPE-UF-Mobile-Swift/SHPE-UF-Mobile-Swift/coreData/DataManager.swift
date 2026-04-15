import CoreData
import Foundation

/// A manager class for handling Core Data operations in the application.
///
/// `DataManager` provides centralized access to the Core Data stack, including the persistent container
/// and managed object context. It handles loading the persistent store, migration of the data model,
/// and provides access to the user data.
///
/// # Example
/// ```swift
/// let dataManager = DataManager()
/// let context = dataManager.managedObjectContext
/// // Use context for Core Data operations
/// ```
class DataManager: NSObject, ObservableObject {
    /// Dynamic properties that the UI will react to
    @Published var shpeito: User = User()
    
    /// Add the Core Data container with the model name
    let container: NSPersistentContainer
    
    /// The managed object context connected to the persistent store coordinator.
    ///
    /// Use this context for all Core Data operations within the application.
    var managedObjectContext: NSManagedObjectContext {
        container.viewContext
    }
    
    /// Initializes the Data Manager and loads the Core Data stack.
    ///
    /// This initializer sets up the persistent container and attempts to load the
    /// persistent stores. If loading fails, it attempts a migration. It also configures
    /// the merge policy to handle conflicts.
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
    /// Attempts to migrate the Core Data store to a new model version.
    ///
    /// This method is called when loading the persistent store fails. It tries to
    /// add the persistent store with migration options enabled. If migration fails,
    /// it clears the Core Data store as a last resort.
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
    /// Clears all data from the Core Data store.
    ///
    /// This method is called when migration fails. It fetches all entity names from
    /// the managed object model and executes a batch delete request for each entity.
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
