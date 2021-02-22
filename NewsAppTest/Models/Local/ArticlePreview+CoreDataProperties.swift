//
//  ArticlePreview+CoreDataProperties.swift
//  NewsAppTest
//
//  Created by Степан Усьянцев on 22.02.2021.
//
//

import Foundation
import CoreData


extension ArticlePreview {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<ArticlePreview> {
        return NSFetchRequest<ArticlePreview>(entityName: "ArticlePreview")
    }

    @NSManaged public var articleDesription: String?
    @NSManaged public var articlePath: String?
    @NSManaged public var dateForSorting: Date?
    @NSManaged public var id: String?
    @NSManaged public var imagePath: String?
    @NSManaged public var isViewed: Bool
    @NSManaged public var publishDate: String?
    @NSManaged public var title: String?
    @NSManaged public var searchKeyword: String?

}

extension ArticlePreview : Identifiable {

}
