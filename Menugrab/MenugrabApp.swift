//
//  MenugrabApp.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 30/12/2020.
//

import SwiftUI

@main
struct MenugrabApp: App {
    
    private static let basket = Basket.sampleBasket
    
    var body: some Scene {
        WindowGroup {
//            HomeView()
//                .environmentObject(Self.basket)
//            TestView(viewModel: TestViewModel(container: AppEnvironment.initialize().container))
            LoadableImageView(viewModel: LoadableImageView.ViewModel(container: AppEnvironment.initialize().container, imageURL: URL(string: "https://i.imgur.com/QypqfcI.jpeg")!))
        }
    }
}
