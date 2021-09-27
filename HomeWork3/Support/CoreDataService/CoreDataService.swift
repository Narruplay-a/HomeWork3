//
//  CoreDataService.swift
//  HomeWork3
//
//  Created by Adel Khaziakhmetov on 14.09.2021.
//

import CoreData

final class CoreDataService {
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Cache")
        container.loadPersistentStores { _, error in
            if let error = error {
                self.handleLoadingPersistantFailed(with: error)
            }
        }
        
        return container
    }()

    var currentContext: NSManagedObjectContext { return persistentContainer.viewContext }
    
    func saveContext() {
        let context = currentContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func handleLoadingPersistantFailed(with error: Error) {
        if let _ = error as NSError? {
            fatalError()
        }
    }
    
    func createObject(for entityName: String) -> NSManagedObject {
        let entityName = entityName.replacingOccurrences(of: "HomeWork3.", with: "")
        let entityDescription = NSEntityDescription.entity(forEntityName: entityName,
                                                           in: currentContext)
        let managedObject = NSManagedObject(entity: entityDescription!,
                                            insertInto: currentContext)
        
        return managedObject
    }

    func getObjects(for name: String) -> [NSManagedObject] {
        let name = name.replacingOccurrences(of: "HomeWork3.", with: "")
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: name)
        var results: [NSManagedObject] = []

        request.includesSubentities = true
        
        do {
            let response = try currentContext.fetch(request)
            results = response.map {
                $0 as! NSManagedObject
            }
        } catch {
            return []
        }
        
        return results
    }


    func deleteObjects(_ objects: [NSManagedObject]) {
        for object in objects {
            currentContext.delete(object)
        }
    }
    
    func clearRepository() {
        currentContext.reset()
    }
}
