//
//  SearchText+CoreDataProperties.swift
//  NewsAppTest
//
//  Created by Степан Усьянцев on 20.02.2021.
//
//

import Foundation
import CoreData


extension SearchText {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<SearchText> {
        return NSFetchRequest<SearchText>(entityName: "SearchText")
    }

    @NSManaged public var dateForSorting: Date
    @NSManaged public var value: String
    @NSManaged public var news: NSSet?

}

// MARK: Generated accessors for news
extension SearchText {

    @objc(addNewsObject:)
    @NSManaged public func addToNews(_ value: ArticlePreview)

    @objc(removeNewsObject:)
    @NSManaged public func removeFromNews(_ value: ArticlePreview)

    @objc(addNews:)
    @NSManaged public func addToNews(_ values: NSSet)

    @objc(removeNews:)
    @NSManaged public func removeFromNews(_ values: NSSet)

}

extension SearchText : Identifiable {

}
