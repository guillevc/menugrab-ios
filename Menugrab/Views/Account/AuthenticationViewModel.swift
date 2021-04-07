//
//  AuthenticationViewModel.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 23/01/2021.
//

import Foundation

final class AuthenticationViewModel: NSObject, ObservableObject {
    @Published var user: Loadable<User>
    @Published var email: String = ""
    @Published var password: String = ""
    
    let container: DIContainer
    private var anyCancellableBag = AnyCancellableBag()
    
    init(
        container: DIContainer,
        user: Loadable<User> = .notRequested
    ) {
        self.container = container
        _user = .init(wrappedValue: user)
    }
    
    func create() {
        container.services.usersService
            .create(user: loadableBinding(\.user), email: email, password: password)
    }
    
    func signIn() {
        container.services.usersService
            .signIn(user: loadableBinding(\.user), email: email, password: password)
    }
    
    func signOut() {
        container.services.usersService.signOut()
    }
    
    func signInAnonymously() {
        container.services.usersService
            .signInAnonymously(user: loadableBinding(\.user))
    }
}
