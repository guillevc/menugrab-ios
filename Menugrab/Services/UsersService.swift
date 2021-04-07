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
    func create(user: Binding<Loadable<User>>, email: String, password: String)
    func signIn(user: Binding<Loadable<User>>, email: String, password: String)
    func signOut()
    func signInAnonymously(user: Binding<Loadable<User>>)
    func updateUser(displayName: String, email: String, password: String)
    func registerFirebaseAuthListeners()
}

struct UsersServiceImpl: UsersService {
    let appState: Store<AppState>
    
    init(appState: Store<AppState>) {
        self.appState = appState
    }
    
    func create(user: Binding<Loadable<User>>, email: String, password: String) {
        let anyCancellableBag = AnyCancellableBag()
        
        user.wrappedValue.setIsLoading(bag: anyCancellableBag)

        Deferred {
            Future<User, Error> { promise in
                Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                    if let error = error as NSError? {
                        promise(.failure(error))
                    } else if let newUser = authResult?.user {
                        promise(.success(newUser))
                    }
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .sinkToLoadable({ user.wrappedValue = $0 })
        .store(in: anyCancellableBag)
    }
    
    func signIn(user: Binding<Loadable<User>>, email: String, password: String) {
        let anyCancellableBag = AnyCancellableBag()
        
        user.wrappedValue.setIsLoading(bag: anyCancellableBag)
        
        Deferred {
            Future<User, Error> { promise in
                Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                    if let error = error {
                        promise(.failure(error))
                    } else if let user = authResult?.user {
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
    
    func signInAnonymously(user: Binding<Loadable<User>>) {
        let anyCancellableBag = AnyCancellableBag()
        
        user.wrappedValue.setIsLoading(bag: anyCancellableBag)
        
        Deferred {
            Future<User, Error> { promise in
                Auth.auth().signInAnonymously { authResult, error in
                    if let error = error {
                        promise(.failure(error))
                    } else if let user = authResult?.user {
                        promise(.success(user))
                    }
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .sinkToLoadable({ user.wrappedValue = $0 })
        .store(in: anyCancellableBag)
    }
    
    func updateUser(displayName: String, email: String, password: String) {
        guard let currentUser = appState[\.currentUser] else { return }
        let createProfileChangeRequest = currentUser.createProfileChangeRequest()
        createProfileChangeRequest.displayName = displayName
        createProfileChangeRequest.commitChanges(completion: nil)
        currentUser.updateEmail(to: email, completion: nil)
        currentUser.updatePassword(to: password, completion: nil)
    }
    
    func registerFirebaseAuthListeners() {
        Auth.auth().addStateDidChangeListener { (_, user) in
            appState[\.currentUser] = user
        }
    }
}

struct UsersServiceStub: UsersService {
    func create(user: Binding<Loadable<User>>, email: String, password: String) { }
    func signIn(user: Binding<Loadable<User>>, email: String, password: String) { }
    func signOut() { }
    func signInAnonymously(user: Binding<Loadable<User>>) { }
    func updateUser(displayName: String, email: String, password: String) { }
    func registerFirebaseAuthListeners() { }
}
