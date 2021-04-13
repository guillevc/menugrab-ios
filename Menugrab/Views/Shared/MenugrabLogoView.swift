//
//  MenugrabLogoView.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 14/04/2021.
//

import SwiftUI

struct MenugrabLogoView: View {
    var body: some View {
        HStack(spacing: 0) {
            Text("menu")
            Text("grab")
                .foregroundColor(.myPrimary)
        }
        .myFont(size: 32, weight: .bold)
    }
}

struct MenugrabLogoView_Previews: PreviewProvider {
    static var previews: some View {
        MenugrabLogoView()
    }
}
