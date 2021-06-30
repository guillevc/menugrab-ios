//
//  MenugrabAppClipApp.swift
//  MenugrabAppClip
//
//  Created by Guillermo Alfonso Varela Chouciño on 08/04/2021.
//

import SwiftUI
import Firebase
import FirebaseMessaging
import UserNotifications
import UserNotificationsUI

fileprivate class AppDelegate: NSObject, UIApplicationDelegate {
    let container = AppEnvironment.initialize(orderType: .table).container
    private var anyCancellableBag = AnyCancellableBag()
    
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
        
        // notifications
        
        UNUserNotificationCenter.current().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })
        application.registerForRemoteNotifications()
        
        Messaging.messaging().delegate = self
        
        return true
    }
}

// MARK: - Notifications

// UIApplicationDelgate notifications related hooks

extension AppDelegate {
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        var readableToken: String = ""
        for i in 0..<deviceToken.count {
            readableToken += String(format: "%02.2hhx", deviceToken[i] as CVarArg)
        }
        print("Received an APNs device token: \(readableToken)")
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("didReceiveRemoteNotification")
        if let notificationData = CurrentOrderStateUpdateNotificationData(from: userInfo) {
            container.services.ordersService.updateCurrentOrderStateUsingNotificationData(notificationData: notificationData)
        }
        completionHandler(UIBackgroundFetchResult.newData)
    }
}

// UNUserNotificationCenterDelegate

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("didReceiveResponse")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        if let notificationData = CurrentOrderStateUpdateNotificationData(from: notification.request.content.userInfo) {
            container.services.ordersService.updateCurrentOrderStateUsingNotificationData(notificationData: notificationData)
        }
        completionHandler([.banner, .badge, .sound])
        print("will Present")
    }
}

// MessagingDelegate

extension AppDelegate: MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let token = fcmToken else { return }
        container.services.usersService.updateFCMToken(fcmToken: token)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    // TODO: handle error
                    print(error.localizedDescription)
                }
            }, receiveValue: { fcmTokenDTO in
                print("updated fcmToken on server to \(fcmTokenDTO.fcmToken)")
            })
            .store(in: anyCancellableBag)
        
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
