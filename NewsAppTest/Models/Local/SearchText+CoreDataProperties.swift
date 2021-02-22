//
//  SearchText+CoreDataProperties.swift
//  NewsAppTest
//
//  Created by Степан Усьянцев on 22.02.2021.
//
//

import Foundation
import CoreData


extension SearchText {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<SearchText> {
        return NSFetchRequest<SearchText>(entityName: "SearchText")
    }

    @NSManaged public var dateForSorting: Date?
    @NSManaged public var value: String?

//    class func saveSearchKeyword(keyword: String, context: NSManagedObjectContext) {
//        let searchText = SearchText(context: context)
//        
//        searchText.value = keyword
//        searchText.dateForSorting = Date()
//    }
}

extension SearchText : Identifiable {

}
