//
//  ContentView.swift
//  LoginKit
//
//  Created by 宋璞 on 2023/8/7.
//

import SwiftUI

struct ContentView: View {
    
    /// View Properties
    
    @State private var showSignup: Bool = false
    /// Keyboard Status
    @State private var isKeyboardShowing: Bool = false
    
    var body: some View {
        NavigationStack {
            Login(showSignup: $showSignup)
                .navigationDestination(isPresented: $showSignup) {
                    SignUp(showSignup: $showSignup)
                }
                /// Checking is Any keyboard is visible
                .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification), perform: { _ in
                    /// Disabling it for signup View
                    if !showSignup {
                        isKeyboardShowing = true
                    }
                })
                .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification), perform: { _ in
                    isKeyboardShowing = false
                })
        }
        .overlay {
            /// iOS 17 Bounce Animation
            if #available(iOS 17, *){
                /// Since this Project Supports iOS 16 too
                CircleView()
                    .animation(.smooth(duration: 0.45, extraBounce: 0), value: showSignup)
                    .animation(.smooth(duration: 0.45, extraBounce: 0), value: isKeyboardShowing)
            } else {
                CircleView()
                    .animation(.easeInOut(duration: 0.3), value: showSignup)
                    .animation(.easeInOut(duration: 0.3), value: isKeyboardShowing)
            }
        }
        
    }
    
    /// Moving Blurred Background
    @ViewBuilder
    func CircleView() -> some View {
        Circle()
            .fill(.linearGradient(colors: [.appYellow, .orange, .red], startPoint: .top, endPoint: .bottom))
            .frame(width: 200, height: 200)
            .offset(x:showSignup ? 90 : -90, y: -90 - (isKeyboardShowing ? 200 : 0))
            .blur(radius: 15)
            .hSpacing(showSignup ? .trailing : .leading)
            .vSpacing(.top)
    }
}

#Preview {
    ContentView()
}
