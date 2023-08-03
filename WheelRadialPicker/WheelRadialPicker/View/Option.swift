//
//  Option.swift
//  WheelRadialPicker
//
//  Created by 宋璞 on 2023/8/1.
//

import SwiftUI

struct Option: View {
    var image: String
    
    var body: some View {
        Button(action: {}) {
            Image(systemName: image)
                .font(.title2)
                .foregroundColor(.white)
        }
    }
}

struct Option_Previews: PreviewProvider {
    static var previews: some View {
        Option(image: "sun.min")
    }
}
