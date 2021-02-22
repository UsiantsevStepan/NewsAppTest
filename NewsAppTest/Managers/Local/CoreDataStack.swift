//
//  CoreDataStack.swift
//  NewsAppTest
//
//  Created by Степан Усьянцев on 22.02.2021.
//

import Foundation
import CoreData

final class CoreDataStack {
    static let instance = CoreDataStack()
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "NewsAppTest")
        //MARK: - Print sqlite file's path
        print(container.persistentStoreDescriptions.first?.url)
        container.viewContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    var childMoc: NSManagedObjectContext {
        let moc = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        moc.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        moc.parent = self.context
        return moc
    }
}
