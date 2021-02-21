//
//  FetchedResultsManager.swift
//  NewsAppTest
//
//  Created by Степан Усьянцев on 21.02.2021.
//

import Foundation
import CoreData

class FetchedResultsManager<T: NSManagedObject>: NSObject, NSFetchedResultsControllerDelegate {
    let fetchedResultsController: NSFetchedResultsController<T>
    
    init(
        delegate: NSFetchedResultsControllerDelegate,
        predicate: NSPredicate?,
        sortDescriptors: [NSSortDescriptor] = [],
        sectionNameKeyPath: String?
    ) {
        let request = NSFetchRequest<T>(entityName: String(describing: T.self))
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors
        
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: NewsManager.context,
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

//private func loadSavedData() {
//    if fetchedResultsController == nil {
//        let request = SearchText.createFetchRequest()
//        let sort = NSSortDescriptor(key: "dateForSorting", ascending: false)
//        request.sortDescriptors = [sort]
//
//        fetchedResultsController = NSFetchedResultsController(
//            fetchRequest: request,
//            managedObjectContext: container.viewContext,
//            sectionNameKeyPath: nil,
//            cacheName: nil
//        )
//        fetchedResultsController.delegate = self
//    }
//
//    do {
//        try fetchedResultsController.performFetch()
//        //            tableView.reloadData()
//    } catch {
//        print("Fetch failed")
//    }
//}

//func loadSavedData() {
//    if fetchedResultsController == nil {
//        let request = ArticlePreview.createFetchRequest()
//        let sort = NSSortDescriptor(key: "dateForSorting", ascending: false)
//        request.sortDescriptors = [sort]
////            request.fetchBatchSize = 20
//        let predicate = NSPredicate(format: "searchText.value CONTAINS %@", searchText)
//        request.predicate = predicate
//        
//        fetchedResultsController = NSFetchedResultsController(
//            fetchRequest: request,
//            managedObjectContext: container.viewContext,
//            //                sectionNameKeyPath: "searchText.searchText",
//            sectionNameKeyPath: "publishDate",
//            cacheName: nil
//        )
//            fetchedResultsController.delegate = self
//    }
//    
//    do {
//        try fetchedResultsController.performFetch()
//    } catch {
//        print("Fetch failed")
//    }
//}
