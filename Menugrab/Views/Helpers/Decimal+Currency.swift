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
