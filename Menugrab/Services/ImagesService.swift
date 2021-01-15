//
//  ImagesService.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 15/01/2021.
//

import SwiftUI

protocol ImagesService {
    func load(image: Binding<Loadable<UIImage>>, url: URL?)
}

struct ImagesServiceImpl: ImagesService {
    let appState: Store<AppState>
    let webRepository: ImagesWebRepository
    
    func load(image: Binding<Loadable<UIImage>>, url: URL?) {
        guard let url = url else {
            image.wrappedValue = .notRequested
            return
        }
        
        let anyCancellableBag = AnyCancellableBag()
        
        image.wrappedValue.setIsLoading(bag: anyCancellableBag)
        
        webRepository.loadImage(url: url)
            .sinkToLoadable {
                image.wrappedValue = $0
            }
            .store(in: anyCancellableBag)
    }
}

struct ImagesServiceStub: ImagesService {
    func load(image: Binding<Loadable<UIImage>>, url: URL?) { }
}
