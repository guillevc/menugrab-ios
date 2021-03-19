//
//  AboutViewModel.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 19/03/2021.
//

import Foundation

final class AboutViewModel: NSObject, ObservableObject {
    @Published var isBlue: Bool
    
    init(isBlue: Bool) {
        self.isBlue = isBlue
    }
    
    func toggleColor() {
        self.isBlue.toggle()
    }
}
