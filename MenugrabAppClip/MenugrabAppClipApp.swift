//
//  MenugrabAppClipApp.swift
//  MenugrabAppClip
//
//  Created by Guillermo Alfonso Varela Chouciño on 08/04/2021.
//

import SwiftUI
import Firebase

fileprivate class AppDelegate: NSObject, UIApplicationDelegate {
    let container: DIContainer = {
        AppEnvironment.initialize(orderType: .table).container
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        container.services.usersService.addAuthStateDidChangeListener { [weak self] user in
            guard let self = self else { return }
            self.container.appState[\.currentUser] = user
            if user != nil {
                self.container.services.usersService.fetchAndUpdateFCMToken()
                self.container.services.ordersService.loadCurrentOrder()
            }
        }
        return true
    }
}

@main
struct MenugrabAppClipApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: .init(container: appDelegate.container))
        }
    }
}
