//
//  ContentViewModel.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 11/03/2021.
//

import Foundation
import Combine

final class ContentViewModel: NSObject, ObservableObject {
    let container: DIContainer
    private var anyCancellableBag = AnyCancellableBag()
    
    var currentUserUpdate: AnyPublisher<User?, Never> {
        container.appState.updates(for: \.currentUser)
    }
    
    var currentOrderUpdate: AnyPublisher<Order?, Never> {
        container.appState.updates(for: \.currentOrder)
    }
    
    init(
        container: DIContainer
    ) {
        self.container = container
    }
}
