//
//  CloudView.swift
//  FlightAppUI
//
//  Created by 宋璞 on 2023/8/3.
//

import SwiftUI

struct CloudView: View {
    var delay: Double
    var size: CGSize
    @State private var moveCloud: Bool = false
    
    var body: some View {
        ZStack {
            Image("Cloud")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: size.width * 3)
                .offset(x: moveCloud ? -size.width * 2 : size.width * 2)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 4.5).delay(delay)) {
                moveCloud.toggle()
            }
        }
    }
}

struct CloudView_Previews: PreviewProvider {
    static var previews: some View {
        CloudView(delay: 3.0, size: CGSize(width: 80, height: 80))
    }
}
