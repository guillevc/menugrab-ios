//
//  AccountViewModel.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 11/03/2021.
//

import Foundation

final class AccountViewModel: NSObject, ObservableObject {
    let container: DIContainer
    private var anyCancellableBag = AnyCancellableBag()
    
    init(
        container: DIContainer
    ) {
        self.container = container
    }

    func signOut() {
        container.services.usersService.signOut()
    }
}
