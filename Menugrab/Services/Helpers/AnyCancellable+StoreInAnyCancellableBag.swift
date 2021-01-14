//
//  AnyCancellable+StoreInAnyCancellableBag.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 14/01/2021.
//

import Foundation
import Combine

extension AnyCancellable {
    func store(in bag: AnyCancellableBag) {
        bag.subscriptions.insert(self)
    }
}
