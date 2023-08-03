//
//  Extension+View.swift
//  QRCodeScanner
//
//  Created by 宋璞 on 2023/8/2.
//

import SwiftUI

/// 设备旋转
struct DeviceRotationViewModifer: ViewModifier {
    
    let action: (UIDeviceOrientation) -> Void
    
    func body(content: Content) -> some View {
        content
            .onAppear()
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                action(UIDevice.current.orientation)
            }
    }
    
    
}


extension View {
    
    func onRotate(perform action: @escaping (UIDeviceOrientation) -> Void) -> some View {
        self.modifier(DeviceRotationViewModifer(action: action))
    }
}
