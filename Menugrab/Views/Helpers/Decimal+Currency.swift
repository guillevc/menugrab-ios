//
//  Decimal+Currency.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 05/01/2021.
//

import Foundation

extension Decimal {
    
    static func currency(_ value: Double) -> Self {
        NSNumber(floatLiteral: value).decimalValue
    }
    
    var formattedAmount: String? {
        let formatter = NumberFormatter()
        formatter.generatesDecimalNumbers = true
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter.string(from: self as NSDecimalNumber)
    }
    
}

struct Currency: CustomStringConvertible {
    
    private let decimal: Decimal
    
    var description: String {
        let formatter = NumberFormatter()
        formatter.generatesDecimalNumbers = true
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter.string(from: decimal as NSDecimalNumber) ?? "-"
    }
    
    private init(decimal: Decimal) {
        self.decimal = decimal
    }
    
    init(_ value: Double) {
        decimal = NSNumber(floatLiteral: value).decimalValue
    }
    
    static func + (left: Self, right: Self) -> Self {
        Currency(decimal: left.decimal.advanced(by: right.decimal))
    }
    
    static func * (left: Self, right: Self) -> Self {
        Currency(decimal: left.decimal * right.decimal)
    }
    
    static func * (left: Self, right: Int) -> Self {
        Currency(decimal: left.decimal * Decimal(right))
    }
    static func * (left: Int, right: Self) -> Self {
        right * left
    }
    
}
