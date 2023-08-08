//
//  View+Extension.swift
//  LoginKit
//
//  Created by 宋璞 on 2023/8/7.
//

import SwiftUI


/// Cunsom SwifUI View Extension
extension View {
    
    /// View Alignment
    /// Instead of using Spacers in someplaces, I've implemented thiscustom modifier to move viewsinside the stack.
    @ViewBuilder
    func hSpacing(_ alignment: Alignment = .center) -> some View {
        self
            .frame(maxWidth: .infinity, alignment: alignment)
    }
    
    @ViewBuilder
    func vSpacing(_ alignment: Alignment = .center) -> some View {
        self
            .frame(maxHeight: .infinity, alignment: alignment)
    }
    
    /// Disable With Opacity
    @ViewBuilder
    func disableWithOpacity(_ condition: Bool) -> some View {
        self
            .disabled(condition)
            .opacity(condition ? 0.5 : 1)
    }
}
