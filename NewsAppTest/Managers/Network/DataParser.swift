//
//  DataParser.swift
//  NewsAppTest
//
//  Created by Степан Усьянцев on 18.02.2021.
//

import Foundation

final class DataParser {
    private let decoder: JSONDecoder
    
    init(decoder: JSONDecoder? = nil) {
        if let jsonDecoder = decoder {
            self.decoder = jsonDecoder
        } else {
            let jsonDecoder = JSONDecoder()
            jsonDecoder.dateDecodingStrategy = .iso8601
            self.decoder = jsonDecoder
        }
    }
    
    func parse<T: Decodable>(withData data: Data, to type: T.Type) -> T? {
        return try? decoder.decode(type, from: data)
    }
}
