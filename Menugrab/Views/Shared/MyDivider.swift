//
//  MyDivider.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 08/01/2021.
//

import SwiftUI

struct MyDivider: View {
    var body: some View {
        Rectangle()
            .frame(height: 1)
            .foregroundColor(.lighterGray)
    }
}

struct MyDivider_Previews: PreviewProvider {
    static var previews: some View {
        MyDivider()
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
