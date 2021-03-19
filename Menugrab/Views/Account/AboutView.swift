//
//  AboutView.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 19/03/2021.
//

import SwiftUI

struct AboutView: View {
    @Environment(\.presentationMode) private var presentationMode
    
    @EnvironmentObject var viewModel: AboutViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            CustomNavigationBarView(title: "About", type: .default, onDismiss: { presentationMode.wrappedValue.dismiss() })
                .background(Color.white)
            Button("Toggle color", action: { viewModel.toggleColor() })
            if viewModel.isBlue {
                Color.blue
            } else {
                Color.red
            }
        }
        .navigationBarHidden(true)
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
