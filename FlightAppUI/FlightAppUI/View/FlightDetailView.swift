//
//  FlightDetailView.swift
//  FlightAppUI
//
//  Created by 宋璞 on 2023/8/2.
//

import SwiftUI

struct FlightDetailView: View {
    
    var alignment: HorizontalAlignment = .leading
    var place: String
    var code: String
    var timing: String
    
    var body: some View {
        VStack(alignment: alignment, spacing: 6) {
            Text(place)
                .font(.caption)
                .foregroundColor(.white.opacity(0.8))
            
            Text(code)
                .font(.title)
                .foregroundColor(.white)
            
            Text(timing)
                .font(.caption)
                .foregroundColor(.white.opacity(0.8))
        }
        .frame(maxWidth: .infinity)
    }
}

struct FlightDetailView_Previews: PreviewProvider {
    static var previews: some View {
        FlightDetailView(alignment: .trailing, place: "New York", code: "NDS", timing: "23 Nov, 03: 45")
    }
}

