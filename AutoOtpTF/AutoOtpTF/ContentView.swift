//
//  ContentView.swift
//  AutoOtpTF
//
//  Created by 宋璞 on 2023/8/7.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        if #available(iOS 15, *) {
            NavigationView {
                OTPVerificationView()
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationBarHidden(true)
            }
        } else {
            NavigationStack {
                OTPVerificationView()
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar(.hidden, for: .navigationBar)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
