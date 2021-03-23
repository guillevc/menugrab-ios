//
//  AppState.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 14/01/2021.
//

import Foundation

struct AppState: Equatable {
    var currentUser: User?
    var number = 0
}

#if DEBUG
extension AppState {
    static var preview: Self {
        .init()
    }
}
#endif
