//
//  OrderDetailsViewModel.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 07/04/2021.
//

import Foundation

final class OrderDetailsViewModel: NSObject, ObservableObject {
    let container: DIContainer
    private var anyCancellableBag = AnyCancellableBag()
    
    init(
        container: DIContainer
    ) {
        self.container = container
    }
}
