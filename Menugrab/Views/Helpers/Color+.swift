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
    
    public static let myPrimary = Color("MyPrimary")
    public static let myPrimaryLight = Color("MyPrimaryLight")
    public static let myPrimaryLighter = Color("MyPrimaryLighter")
    public static let myPrimaryDark = Color("MyPrimaryDark")
    public static let myPrimaryDarker = Color("MyPrimaryDarker")
    
    public static let myBlack = Color("MyBlack")
    
    public static let darkGray = Self(UIColor.darkGray)
    public static let lightGray = Self(UIColor.lightGray)
    public static let lighterGray = Self(UIColor.systemGray5)
    public static let lightestGray = Color("LightestGray")
    
}
