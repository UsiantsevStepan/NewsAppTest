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
            // MARK: - 4 Api keys in case if one is not enough for you :) Each allows 100 request per day (updates every 12 hours)
            //            "apiKey" : "0fa2296c3e0c4b03bcffabfc169fa429",
            //            "apiKey" : "becccb11743f4549879559158c4606df",
//            "apiKey" : "8c2922169e7a44ec9c42958aed00a3fa",
            "apiKey" : "cf6372e3eea84ae1af5a369d33f9f65a",
            "language" : "en",
            "sortBy" : "publishedAt"
        ]
        
        switch self {
        case let .searchNews(text: text, page: page):
            queryParams.updateValue(text, forKey: "q")
            queryParams.updateValue("\(page)", forKey: "page")
            return queryParams
            
        case let .searchNewsUpTo(text: text, date: date):
            queryParams.updateValue(text, forKey: "q")
            queryParams.updateValue(date, forKey: "to")
            return queryParams
            
        case let .searchNewsFrom(text: text, date: date, page: page):
            queryParams.updateValue(text, forKey: "q")
            queryParams.updateValue(date, forKey: "from")
            queryParams.updateValue("\(page)", forKey: "page")
            return queryParams
        }
        
    }
}
