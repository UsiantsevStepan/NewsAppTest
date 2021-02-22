//
//  SearchText+CoreDataProperties.swift
//  NewsAppTest
//
//  Created by Степан Усьянцев on 22.02.2021.
//
//

import Foundation
import CoreData

@objc(SearchText)
public class SearchText: NSManagedObject, Identifiable {
    @nonobjc public class func createFetchRequest() -> NSFetchRequest<SearchText> {
        return NSFetchRequest<SearchText>(entityName: "SearchText")
    }
    
    @NSManaged public var dateForSorting: Date?
    @NSManaged public var value: String?
}
