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

enum CustomNavigationBarRightButtonType: CaseIterable {
    case save
}

struct CustomNavigationBarView: View {
    private let title: String
    private let type: CustomNavigationBarViewType
    private let onDismiss: (() -> ())?
    private let rightButtonType: CustomNavigationBarRightButtonType?
    private let onRightButtonTapped: (() -> ())?
    
    init(title: String,
         type: CustomNavigationBarViewType,
         onDismiss: (() -> ())?,
         rightButtonType: CustomNavigationBarRightButtonType? = nil,
         onRightButtonTapped: (() -> ())? = nil) {
        self.title = title
        self.type = type
        self.onDismiss = onDismiss
        self.rightButtonType = rightButtonType
        self.onRightButtonTapped = onRightButtonTapped
    }
    
    var body: some View {
        ZStack {
            HStack(alignment: .center) {
                Button(action: { onDismiss?() }) {
                    Image(systemName: type == .default ? "arrow.left" : "xmark")
                        .font(.system(size: 20))
                        .foregroundColor(.myBlack)
                }
                Spacer()
                if let rightButtonType = rightButtonType {
                    switch rightButtonType {
                    case .save:
                        Button(action: { onRightButtonTapped?() } ) {
                            Text("Save")
                                .myFont(size: 17, weight: .bold, color: .myPrimary)
                        }
                    }
                }
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
                CustomNavigationBarView(title: "Navigation bar title", type: type, onDismiss: nil)
            }
            ForEach(CustomNavigationBarRightButtonType.allCases, id: \.self) { type in
                CustomNavigationBarView(title: "Navigation bar title", type: .default, onDismiss: nil, rightButtonType: type)
            }
        }
        .previewLayout(.sizeThatFits)
    }
}
