//
//  CoreDataServices.swift
//  MyStore
//
//  Created by Samuelabraham D on 27/07/24.
//

import Foundation
import CoreData

class CoreDataServices {
    
    // MARK: - CoreData Stack
    private let name:String = "StoreRepository"
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: name)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                Logger.log(error.userInfo)
            }
            container.viewContext.automaticallyMergesChangesFromParent = true
            container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        })
        return container
    }()
    
    private lazy var context = persistentContainer.viewContext
    
    // MARK: - Saving
    func saveContext(handler: (() -> Void)? = nil) {
        if self.context.hasChanges {
            do {
                try self.context.save()
                handler?()
            } catch(let error) {
                Logger.log(error)
                handler?()
            }
        }
    }
    
    // MARK: - Fetch
    func fetchManagedObject<T: NSManagedObject>(request: NSFetchRequest<T>,  sortBy: [NSSortDescriptor]? = nil, predicate: NSPredicate? = nil) throws -> [T]? {
        do {
            request.predicate = predicate
            request.sortDescriptors = sortBy
            let result = try context.fetch(request)
            return result
        } catch let error as NSError {
            Logger.log(error.localizedDescription)
        }
        return nil
    }
    
    // MARK: - Delete One Table Record
    func deleteOneTableRecodes(entity : String, handler:(Bool?, String) -> Void?) {
        let managedContext = self.persistentContainer.viewContext
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try managedContext.execute(deleteRequest)
            try managedContext.save()
            Logger.log("deleted entity \(entity)")
        } catch let error as NSError {
            Logger.log(error.localizedDescription)
        }
        handler(true, entity)
    }
    
    func getContext() -> NSManagedObjectContext { return context }
}

extension NSManagedObjectContext {
    func saveIfChanged() -> NSError? {
        guard hasChanges else {return nil}
        do {
            try save()
            return nil
        } catch {
            return error as NSError
        }
    }
}
