//
//  Color+.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 30/12/2020.
//

import SwiftUI

// https://medium.com/better-programming/custom-colors-and-modifiers-in-swiftui-a093c243c126
// https://developer.apple.com/design/human-interface-guidelines/ios/visual-design/color/
extension Color {
    static let myPrimary = Color("MyPrimary")
    static let myPrimaryLight = Color("MyPrimaryLight")
    static let myPrimaryLighter = Color("MyPrimaryLighter")
    static let myPrimaryDark = Color("MyPrimaryDark")
    static let myPrimaryDarker = Color("MyPrimaryDarker")
    
    static let myBlack = Color("MyBlack")
    
    static let darkGray = Self(UIColor.darkGray)
    static let lightGray = Self(UIColor.lightGray)
    static let lightestGray = Color("LightestGray")
    static let backgroundGray = Color("BackgroundGray")
    
    static let errorRed = Color("ErrorRed")
}
