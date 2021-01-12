//
//  Date+.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 12/01/2021.
//

import Foundation

extension Date {
    func formatted() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: self)
    }
}
