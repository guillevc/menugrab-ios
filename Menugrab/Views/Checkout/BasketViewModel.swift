//
//  BasketViewModel.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 26/03/2021.
//

import Foundation

final class BasketViewModel: NSObject, ObservableObject {
    let container: DIContainer
    private var anyCancellableBag = AnyCancellableBag()
    
    init(
        container: DIContainer
    ) {
        self.container = container
    }
}
