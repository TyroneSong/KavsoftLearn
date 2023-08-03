//
//  FunctionButton.swift
//  WheelRadialPicker
//
//  Created by 宋璞 on 2023/8/1.
//

import SwiftUI

struct FunctionButton: View {
    var image: String
    var angle: Double
    @State var circleWidth = UIScreen.main.bounds.width / 1.5
    @Binding var current: Int
    var index: Int
    
    var body: some View {
        Image(systemName: image)
            .font(.system(size: 24, weight: .heavy))
            .foregroundColor(.black)
            .rotationEffect(Angle(degrees: -angle))
            .padding()
            .background(Color.red.opacity(current == index ? 0.5 : 0))
            .clipShape(Circle())
            .offset(x: -circleWidth / 2)
            .rotationEffect(Angle(degrees: angle))
    }
}


