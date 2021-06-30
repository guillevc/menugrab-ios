//
//  Date+.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 12/01/2021.
//

import Foundation

extension DateFormatter {
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
    
    static let isoStringWithoutMillisFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter
    }()
    
    static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
}

extension Date {
    init?(isoStringWithoutMillis string: String) {
        if let date = DateFormatter.isoStringWithoutMillisFormatter.date(from: string) {
            self = date
        } else {
            return nil
        }
    }
    
    var formatted: String {
        DateFormatter.dateFormatter.string(from: self)
    }
    
    var timeFormatted: String {
        DateFormatter.timeFormatter.string(from: self)
    }
}
