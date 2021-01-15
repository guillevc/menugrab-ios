//
//  ImagesWebRepository.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 15/01/2021.
//

import SwiftUI
import Combine

protocol ImagesWebRepository {
    func loadImage(url: URL) -> AnyPublisher<UIImage, Error>
}

struct ImagesWebRepositoryImpl: ImagesWebRepository {
    let session: URLSession
    let baseURL: String
    let backgroundQueue = DispatchQueue(label: "background_parse_queue")
    
    func loadImage(url: URL) -> AnyPublisher<UIImage, Error> {
        let urlRequest = URLRequest(url: url)
        return session
            .dataTaskPublisher(for: urlRequest)
            .tryMap { (data, response) in
                guard let image = UIImage(data: data) else {
                    throw APIError.imageProcessing
                }
                return image
            }
            .subscribe(on: backgroundQueue)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
