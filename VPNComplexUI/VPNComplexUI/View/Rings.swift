//
//  Rings.swift
//  VPNComplexUI
//
//  Created by 宋璞 on 2023/8/3.
//

import SwiftUI

struct Rings: View {
    var width: CGFloat
    @Binding var isServerOn: Bool
    
    var body: some View {
        ZStack {
            ForEach(1...60, id: \.self) { index in
                Circle()
                    .fill(isServerOn ? .green : .white)
                    .frame(width: getSize(index), height: getSize(index))
                    .offset(x: -(width / 2))
                    .rotationEffect(.degrees(Double(index) * 6))
                    .opacity(getSize(index) == 3 ? 0.7 : (isServerOn ? 1 : 0.8))
            }
        }
        .frame(width: width)
        .rotationEffect(Angle(degrees: 90))
        
        
    }
    
    func getSize(_ index: Int) -> CGFloat {
        if index < 10 || index > 50 {
            return 3
        }
        
        if index >= 10 && index < 20 {
            return 4
        }
        
        if index >= 40 && index <= 50 {
            return 4
        } else {
            return 5
        }
    }
}

struct Rings_Previews: PreviewProvider {
    static var previews: some View {
        Rings(width: 300, isServerOn: .constant(true))
    }
}
