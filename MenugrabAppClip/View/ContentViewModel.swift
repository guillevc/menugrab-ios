//
//  ContentViewModel.swift
//  MenugrabAppClip
//
//  Created by Guillermo Alfonso Varela Chouciño on 08/04/2021.
//

import Foundation
import Combine

final class ContentViewModel: NSObject, ObservableObject {
    @Published var user: Loadable<User>
    
    let container: DIContainer
    private var anyCancellableBag = AnyCancellableBag()
    
    var currentUserUpdate: AnyPublisher<User?, Never> {
        container.appState.updates(for: \.currentUser)
    }
    
    init(
        container: DIContainer,
        user: Loadable<User> = .notRequested
    ) {
        self.container = container
        _user = .init(wrappedValue: user)
    }
    
    func signInAnonymously() {
        container.services.usersService
            .signInAnonymously(user: loadableBinding(\.user))
    }
}
