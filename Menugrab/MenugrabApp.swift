//
//  MenugrabApp.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 30/12/2020.
//

import SwiftUI
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct MenugrabApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    private static let basket = Basket.sampleBasket
    
    var body: some Scene {
        WindowGroup {
//            HomeView()
//                .environmentObject(Self.basket)
            TestView(viewModel: TestViewModel(container: AppEnvironment.initialize().container))
        }
    }
}
