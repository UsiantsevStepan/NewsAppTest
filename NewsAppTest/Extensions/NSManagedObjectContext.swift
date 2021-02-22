//
//  NSManagedObjectContext.swift
//  NewsAppTest
//
//  Created by Степан Усьянцев on 22.02.2021.
//

import Foundation
import CoreData

extension NSManagedObjectContext {
    // MARK: - Core Data Saving support
    func saveContext(completion: (() -> Void)? = nil) {
        if hasChanges {
            do {
                try save()
                completion?()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

