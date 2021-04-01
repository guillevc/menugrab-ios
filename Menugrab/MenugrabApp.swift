//
//  MenugrabApp.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 30/12/2020.
//

import SwiftUI
import Firebase

fileprivate class AppDelegate: NSObject, UIApplicationDelegate {
    let container = AppEnvironment.initialize().container
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        container.services.usersService.registerFirebaseAuthListeners()
        return true
    }
}

@main
struct MenugrabApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: ContentViewModel(container: appDelegate.container))
        }
    }
}
