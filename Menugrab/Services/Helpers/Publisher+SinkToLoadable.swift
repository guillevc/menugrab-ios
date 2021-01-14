//
//  Publisher+.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 14/01/2021.
//

import Combine
import SwiftUI

extension Publisher {
    func sinkToLoadable(_ completion: @escaping (Loadable<Output>) -> Void) -> AnyCancellable {
        return sink(receiveCompletion: { subscriptionCompletion in
            if case let Subscribers.Completion.failure(error) = subscriptionCompletion {
                completion(.failed(error))
            }
        }, receiveValue: { value in
            completion(.loaded(value))
        })
    }
}
