//
//  Formatter.swift
//  NewsAppTest
//
//  Created by Степан Усьянцев on 23.02.2021.
//

import Foundation

extension ISO8601DateFormatter {
    convenience init(_ formatOptions: Options) {
        self.init()
        self.formatOptions = formatOptions
    }
}

extension Formatter {
    static let iso8601withFractionalSeconds = ISO8601DateFormatter([.withInternetDateTime, .withFractionalSeconds])
}

extension Date {
    var iso8601withFractionalSeconds: String {
        return Formatter.iso8601withFractionalSeconds.string(from: self)
    }
}
