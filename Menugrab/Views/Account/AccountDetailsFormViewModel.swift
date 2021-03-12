//
//  AccountDetailsFormViewModel.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 11/03/2021.
//

import Foundation

final class AccountDetailsFormViewModel: NSObject, ObservableObject {
    @Published var name: String
    @Published var email: String
    @Published var newPassword: String = ""
    @Published var newPasswordRepeat: String = ""
    
    let container: DIContainer
    private var anyCancellableBag = AnyCancellableBag()
    
    init(
        container: DIContainer
    ) {
        self.container = container
        let currentUser = container.appState.value.currentUser
        self.name = currentUser?.displayName ?? ""
        self.email = currentUser?.email ?? ""
    }
    
    func updateUser() {
        container.services.usersService.updateUser(displayName: name, email: email, password: newPassword)
    }
}
