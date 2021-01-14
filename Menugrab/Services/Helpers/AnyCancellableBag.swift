//
//  CancellableBag.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 14/01/2021.
//

import Combine

final class AnyCancellableBag {
    var subscriptions = Set<AnyCancellable>()
    
    func cancelAll() {
        subscriptions.removeAll()
    }
}
