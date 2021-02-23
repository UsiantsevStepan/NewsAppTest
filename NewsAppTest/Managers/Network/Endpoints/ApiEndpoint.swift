//
//  ApiEndpoint.swift
//  NewsAppTest
//
//  Created by Степан Усьянцев on 18.02.2021.
//

import Foundation

public enum ApiEndpoint {
    case searchNews(text: String, page: Int)
    case searchNewsUpTo(text: String, date: String)
    case searchNewsFrom(text: String, date: String, page: Int)
}

extension ApiEndpoint: EndpointProtocol {
    var baseURL: String {
        return "https://newsapi.org/v2"
    }
    
    var fullURL: String {
        switch self {
        case .searchNews:
            return baseURL + "/everything"
        case .searchNewsUpTo:
            return baseURL + "/everything"
        case .searchNewsFrom:
            return baseURL + "/everything"
        }
    }
    
    var params: [String : String] {
        var queryParams = [
            "apiKey" : "8c2922169e7a44ec9c42958aed00a3fa",
            "language" : "en",
            "sortBy" : "publishedAt"
        ]
        
        switch self {
        case let .searchNews(text: text, page: page):
            queryParams["q"] = text
            queryParams["page"] = "\(page)"
            return queryParams
            
        case let .searchNewsUpTo(text: text, date: date):
            queryParams["q"] = text
            queryParams["to"] = date
            return queryParams
            
        case let .searchNewsFrom(text: text, date: date, page: page):
            queryParams["q"] = text
            queryParams["page"] = "\(page)"
            queryParams["from"] = date
            return queryParams
        }
        
    }
}
