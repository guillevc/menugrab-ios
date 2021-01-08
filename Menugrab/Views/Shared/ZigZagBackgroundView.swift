//
//  ZigZagSeparatorView.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 01/01/2021.
//

import SwiftUI

struct ZigZagBackgroundView: View {
    let color: Color
    let numberOfTriangles: Int
    let triangleHeight: Int
    
    var body: some View {
        ZStack {
            color
            GeometryReader { geometry in
                let triangleWidth = Float(geometry.size.width) / Float(numberOfTriangles)
                Path { path in
                    path.move(to: CGPoint(x: 0, y: 0))
                    var x = 0
                    while Float(x) < Float(geometry.size.width) {
                        x += Int(triangleWidth/2.0)
                        path.addLine(to: CGPoint(x: x, y: triangleHeight))
                        x += Int(triangleWidth/2.0)
                        path.addLine(to: CGPoint(x: x, y: 0))
                    }
                }
                .fill(Color.white)
            }
        }
    }
}

struct ZigZagSeparatorView_Previews: PreviewProvider {
    static var previews: some View {
        ZigZagBackgroundView(color: .lightestGray, numberOfTriangles: 20, triangleHeight: 10)
    }
}
