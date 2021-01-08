//
//  CustomNavigationBarView.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 08/01/2021.
//

import SwiftUI

enum CustomNavigationBarViewType: CaseIterable {
    case `default`
    case sheet
}

struct CustomNavigationBarView: View {
    let type: CustomNavigationBarViewType
    let title: String
    let onDismiss: (() -> ())?
    
    var body: some View {
        ZStack {
            HStack(alignment: .center) {
                Button(action: { onDismiss?() }) {
                    Image(systemName: type == .default ? "arrow.left" : "xmark")
                        .font(.system(size: 20))
                        .foregroundColor(.myBlack)
                }
                Spacer()
            }
            Text(title)
                .myFont(size: 17, weight: .medium)
        }
        .padding()
        .frame(height: Constants.customNavigationBarHeight)
    }
}

struct CustomNavigationBarView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ForEach(CustomNavigationBarViewType.allCases, id: \.self) { type in
                CustomNavigationBarView(type: type, title: "Navigation bar title", onDismiss: nil)
            }
            .previewLayout(.sizeThatFits)
        }
    }
}
