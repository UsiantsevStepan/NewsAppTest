//
//  NewsData.swift
//  NewsAppTest
//
//  Created by Степан Усьянцев on 18.02.2021.
//

import Foundation

struct NewsData: Decodable {
    let totalResults: Int
    let articles: [Article]
}

struct Article: Decodable {
    let title: String?
    let description: String?
    let url: String
    let urlToImage: String?
    let publishedAt: Date
}
