//
//  RoundedRectangleSpecificCorners.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 17/01/2021.
//

import SwiftUI

struct RoundedRectangleSpecificCorners: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
