//
//  UsersService.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 21/01/2021.
//

import Foundation
import SwiftUI
import Combine
import FirebaseAuth
import FirebaseMessaging


protocol UsersService {
    func create(user: Binding<Loadable<User>>, email: String, password: String)
    func signIn(user: Binding<Loadable<User>>, email: String, password: String)
    func signOut()
    func signInAnonymously(user: Binding<Loadable<User>>)
    func updateUser(displayName: String, email: String, password: String)
    func addAuthStateDidChangeListener(listener: @escaping (User?) -> ())
    func updateFCMToken(fcmToken: String) -> AnyPublisher<FCMTokenDTO, Error>
    func fetchAndUpdateFCMToken()
}

struct UsersServiceImpl: UsersService {
    let appState: Store<AppState>
    let webRepository: UsersWebRepository
    private let anyCancellableBag = AnyCancellableBag()
    
    init(appState: Store<AppState>, webRepository: UsersWebRepository) {
        self.appState = appState
        self.webRepository = webRepository
    }
    
    // MARK: - UsersService
    
    func create(user: Binding<Loadable<User>>, email: String, password: String) {
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
    
    func addAuthStateDidChangeListener(listener: @escaping (User?) -> ()) {
        Auth.auth().addStateDidChangeListener { (_, user) in
            listener(user)
        }
    }
    
    func updateFCMToken(fcmToken: String) -> AnyPublisher<FCMTokenDTO, Error> {
        guard let currentUser = appState[\.currentUser] else {
            return Fail(outputType: FCMTokenDTO.self, failure: MenugrabAppError.unauthenticatedUser)
                .eraseToAnyPublisher()
        }
        let fcmTokenDTO = FCMTokenDTO(fcmToken: fcmToken)
        return webRepository.updateFCMToken(userId: currentUser.uid, fcmTokenDTO: fcmTokenDTO)
            .eraseToAnyPublisher()
    }
    
    func fetchAndUpdateFCMToken() {
        Deferred {
            Future<String, Error> { promise in
                Messaging.messaging().token { fcmToken, error in
                    if let error = error {
                        promise(.failure(error))
                    } else if let token = fcmToken {
                        promise(.success(token))
                    }
                }
            }
        }
        .flatMap(updateFCMToken(fcmToken:))
        .receive(on: DispatchQueue.main)
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

struct UsersServiceStub: UsersService {
    func create(user: Binding<Loadable<User>>, email: String, password: String) { }
    func signIn(user: Binding<Loadable<User>>, email: String, password: String) { }
    func signOut() { }
    func signInAnonymously(user: Binding<Loadable<User>>) { }
    func updateUser(displayName: String, email: String, password: String) { }
    func addAuthStateDidChangeListener(listener: @escaping (User?) -> ()) { }
    func updateFCMToken(fcmToken: String) -> AnyPublisher<FCMTokenDTO, Error> {
        Fail(outputType: FCMTokenDTO.self, failure: MenugrabAppError.unauthenticatedUser)
            .eraseToAnyPublisher()
    }
    func fetchAndUpdateFCMToken() { }
}

// MARK: - DTOs

struct FCMTokenDTO: Decodable, Encodable {
    let fcmToken: String
}
