//
//  DataParser.swift
//  NewsAppTest
//
//  Created by Степан Усьянцев on 18.02.2021.
//

import Foundation

class DataParser {
    private let decoder: JSONDecoder
    
    init(decoder: JSONDecoder = JSONDecoder()) {
        self.decoder = decoder
    }
    
    func parse<T: Decodable>(withData data: Data, to type: T.Type) -> T? {
        return try? decoder.decode(type, from: data)
    }
}
