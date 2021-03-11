//
//  AppState.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 14/01/2021.
//

import Foundation

struct AppState: Equatable {
    var currentUser: User?
}

#if DEBUG
extension AppState {
    static var preview: Self {
        .init(currentUser: nil)
    }
}
#endif
