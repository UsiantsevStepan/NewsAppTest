//
//  FetchedResultsManager.swift
//  NewsAppTest
//
//  Created by Степан Усьянцев on 21.02.2021.
//

import Foundation
import CoreData

final class FetchedResultsManager<T: NSManagedObject>: NSObject, NSFetchedResultsControllerDelegate {
    let fetchedResultsController: NSFetchedResultsController<T>
    
    init(
        delegate: NSFetchedResultsControllerDelegate? = nil,
        predicate: NSPredicate? = nil,
        sortDescriptors: [NSSortDescriptor] = [],
        sectionNameKeyPath: String? = nil
    ) {
        let request = NSFetchRequest<T>(entityName: String(describing: T.self))
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors
        
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: CoreDataStack.instance.context,
            sectionNameKeyPath: sectionNameKeyPath,
            cacheName: nil
        )
        
        super.init()
        
        fetchedResultsController.delegate = delegate
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            let error = error as NSError
            fatalError("Unresolved error: \(error), \(error.userInfo)")
        }
    }
}
