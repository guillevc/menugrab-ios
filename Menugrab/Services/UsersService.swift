//
//  UsersService.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 21/01/2021.
//

import Foundation
import SwiftUI
import FirebaseAuth
import Combine


protocol UsersService {
    func create(user: Binding<Loadable<FirebaseAuth.User>>, email: String, password: String)
    func signIn(user: Binding<Loadable<FirebaseAuth.User>>, email: String, password: String)
    func signOut()
    func isAuthenticated() -> Bool
}

struct UsersServiceImpl: UsersService {
    let appState: Store<AppState>
    
    init(appState: Store<AppState>) {
        self.appState = appState
    }
    
    func create(user: Binding<Loadable<FirebaseAuth.User>>, email: String, password: String) {
        let anyCancellableBag = AnyCancellableBag()
        
        user.wrappedValue.setIsLoading(bag: anyCancellableBag)

        Deferred {
            Future<FirebaseAuth.User, Error> { promise in
                Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                    if let error = error as NSError? {
                        promise(.failure(error))
                    } else if let newUser = Auth.auth().currentUser {
                        promise(.success(newUser))
                    }
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .sinkToLoadable({ user.wrappedValue = $0 })
        .store(in: anyCancellableBag)
    }
    
    func signIn(user: Binding<Loadable<FirebaseAuth.User>>, email: String, password: String) {
        let anyCancellableBag = AnyCancellableBag()
        
        user.wrappedValue.setIsLoading(bag: anyCancellableBag)
        
        Deferred {
            Future<FirebaseAuth.User, Error> { promise in
                Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                    if let error = error {
                        promise(.failure(error))
                    } else if let user = Auth.auth().currentUser {
                        promise(.success(user))
                    }
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .sinkToLoadable({ user.wrappedValue = $0 })
        .store(in: anyCancellableBag)
    }
    
    func signOut() {
        try? Auth.auth().signOut()
    }
    
    func isAuthenticated() -> Bool {
        Auth.auth().currentUser != nil
    }
}

struct UsersServiceStub: UsersService {
    func create(user: Binding<Loadable<FirebaseAuth.User>>, email: String, password: String) { }
    func signIn(user: Binding<Loadable<FirebaseAuth.User>>, email: String, password: String) { }
    func signOut() { }
    func isAuthenticated() -> Bool { return true }
}
