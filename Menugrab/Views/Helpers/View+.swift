//
//  Text+.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 30/12/2020.
//

import SwiftUI

extension View {
    
    func myFont(size: CGFloat = 15, weight: Font.Weight = .regular, color: Color = .myBlack) -> some View {
        let font = Font.custom("DM Sans", size: size).weight(weight)
        return self.font(font).foregroundColor(color)
    }
    
    func eraseToAnyView() -> AnyView { AnyView(self) }
    
}
