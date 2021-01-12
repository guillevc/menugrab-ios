//
//  LinkViewIfURLNotNull.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 07/01/2021.
//

import SwiftUI

struct LinkIfDestinationNotNull<Content: View>: View {
    let url: URL?
    let content: Content
    
    init(destination: URL?, @ViewBuilder content: @escaping () -> Content) {
        self.url = destination
        self.content = content()
    }
    
    var body: some View {
        if let url = url {
            Link(destination: url) {
                content
            }
            .buttonStyle(PlainButtonStyle())
        } else {
            content
        }
    }
}
