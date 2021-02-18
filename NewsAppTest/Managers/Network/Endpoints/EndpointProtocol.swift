//
//  EndpointProtocol.swift
//  NewsAppTest
//
//  Created by Степан Усьянцев on 18.02.2021.
//

import Foundation

protocol EndpointProtocol {
    var baseURL: String { get }
    var fullURL: String { get }
    var params: [String: String] { get }
}
