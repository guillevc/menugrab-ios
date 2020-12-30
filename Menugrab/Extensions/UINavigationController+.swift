//
//  UINavigationController+.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 30/12/2020.
//

import UIKit
import SwiftUI

// Custom navigation view appearance - https://schwiftyui.com/swiftui/customizing-your-navigationviews-bar-in-swiftui/
// Preserve swipe back gesture - https://stackoverflow.com/questions/59921239/hide-navigation-bar-without-losing-swipe-back-gesture-in-swiftui
extension UINavigationController: UIGestureRecognizerDelegate  {
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        // Custom navigation view appearance
        let textColor = UIColor(Color.myBlack)
        let backgroundColor = UIColor.white
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = backgroundColor
        appearance.titleTextAttributes = [.foregroundColor: textColor, .font: UIFont(name: "DMSans-Bold", size: 17)!]
        appearance.largeTitleTextAttributes = [.foregroundColor: textColor]
        appearance.shadowColor = UIColor(Color.lightGray)
        appearance.setBackIndicatorImage(UIImage(named: "arrow.left"), transitionMaskImage: UIImage(named: "arrow.left"))
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        
        UINavigationBar.appearance().tintColor = textColor
        
        // Preserve swipe back gesture
        interactivePopGestureRecognizer?.delegate = self
    }
    
    // Preserve swipe back gesture
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
    
}
