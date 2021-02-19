//
//  ArticlePreview+CoreDataProperties.swift
//  NewsAppTest
//
//  Created by Степан Усьянцев on 19.02.2021.
//
//

import Foundation
import CoreData


extension ArticlePreview {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<ArticlePreview> {
        return NSFetchRequest<ArticlePreview>(entityName: "ArticlePreview")
    }

    @NSManaged public var articleDesription: String?
    @NSManaged public var articlePath: String
    @NSManaged public var imagePath: String?
    @NSManaged public var isViewed: Bool
    @NSManaged public var publishDate: String
    @NSManaged public var title: String?
    @NSManaged public var dateForSorting: Date
    @NSManaged public var searchText: NSSet?

}

// MARK: Generated accessors for searchText
extension ArticlePreview {

    @objc(addSearchTextObject:)
    @NSManaged public func addToSearchText(_ value: SearchText)

    @objc(removeSearchTextObject:)
    @NSManaged public func removeFromSearchText(_ value: SearchText)

    @objc(addSearchText:)
    @NSManaged public func addToSearchText(_ values: NSSet)

    @objc(removeSearchText:)
    @NSManaged public func removeFromSearchText(_ values: NSSet)

}

extension ArticlePreview : Identifiable {

}
