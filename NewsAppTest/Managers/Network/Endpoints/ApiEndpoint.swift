//
//  ApiEndpoint.swift
//  NewsAppTest
//
//  Created by Степан Усьянцев on 18.02.2021.
//

import Foundation

public enum ApiEndpoint {
    case searchNews(text: String, page: Int)
}

extension ApiEndpoint: EndpointProtocol {
    var baseURL: String {
        return "https://newsapi.org/v2"
    }
    
    var fullURL: String {
        switch self {
        case .searchNews:
            return baseURL + "/everything"
        }
    }
    
    var params: [String : String] {
        var queryParams = [
            "apiKey" : "0fa2296c3e0c4b03bcffabfc169fa429",
            "language" : Locale.current.regionCode ?? "en",
            "sortBy" : "publishedAt"
        ]
        
        switch self {
        case let .searchNews(text: text, page: page):
            queryParams.updateValue(text, forKey: "q")
            queryParams.updateValue("\(page)", forKey: "page")
            
            return queryParams
        }
    }
}
