//
//  AboutView.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 19/03/2021.
//

import SwiftUI

struct AboutView: View {
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            CustomNavigationBarView(title: "About", type: .default, onDismiss: { presentationMode.wrappedValue.dismiss() })
                .background(Color.white)
            VStack(alignment: .leading) {
            Text("Made by Guillermo Alfonso Varela Chouciño")
                .myFont(size: 18, weight: .regular)
                Link("Visit my GitHub page ->", destination: URL(string: "http://github.com/guillevc")!)
                    .myFont(size: 18, weight: .regular, color: .myPrimaryDark)
            }
            .padding()
            Spacer()
        }
        .navigationBarHidden(true)
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
