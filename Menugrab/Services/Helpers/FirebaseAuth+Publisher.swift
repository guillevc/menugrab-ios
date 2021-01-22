//
//  FirebaseAuth+Publisher.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 22/01/2021.
//

import FirebaseAuth
import Combine

extension FirebaseAuth.Auth {
    func currentUserIdTokenPublisher(forcingRefresh: Bool = false) -> AnyPublisher<String?, Error> {
        return Deferred {
            Future<String?, Error> { promise in
                guard let currentUser = self.currentUser else {
                    return promise(.success(nil))
                }
                currentUser.getIDTokenForcingRefresh(forcingRefresh) { idToken, error in
                    if let error = error {
                        return promise(.failure(error))
                    } else if let idToken = idToken {
                        return promise(.success(idToken))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
