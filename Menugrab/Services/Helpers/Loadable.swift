//
//  LoadableSubject.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 13/01/2021.
//

import Foundation
import SwiftUI
import Combine

enum Loadable<T> {
    
    case notRequested
    case isLoading(last: T?, bag: AnyCancellableBag)
    case loaded(T)
    case failed(Error)
    
    var value: T? {
        switch self {
        case let .isLoading(last, _):
            return last
        case let .loaded(value):
            return value
        default:
            return nil
        }
    }
    
    var error: Error? {
        if case let .failed(error) = self {
            return error
        } else {
            return nil
        }
    }
    
    mutating func setIsLoading(bag: AnyCancellableBag) {
        self = .isLoading(last: value, bag: bag)
    }
    
    mutating func cancelLoading() {
        if case let .isLoading(last, bag) = self {
            bag.cancelAll()
            if let last = last {
                self = .loaded(last)
            } else {
                let error = NSError(domain: NSCocoaErrorDomain,
                                    code: NSUserCancelledError,
                                    userInfo: [NSLocalizedDescriptionKey: NSLocalizedString("Canceled by user", comment: "")])
                self = .failed(error)
            }
        }
    }
    
//    func map<S>(_ transform: (T) throws -> S) -> Loadable<S> {
//        do {
//            switch self {
//
//            }
//        }
//    }
}

