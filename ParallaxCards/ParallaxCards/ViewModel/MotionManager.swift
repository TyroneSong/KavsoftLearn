//
//  MotionManager.swift
//  ParallaxCards
//
//  Created by 宋璞 on 2024/2/21.
//

import SwiftUI
import CoreMotion

class MotionManager: ObservableObject {
    // MARK: - Motion Manager Properties ⚡️
    @Published var manager: CMMotionManager = .init()
    @Published var xValue: CGFloat = 0
    @Published var yValue: CGFloat = 0
    // MARK: - Current Slide ⚡️
    @Published var currentSlider: Place = sample_places.first!
    
    func detectMotion() {
        
        if !manager.isDeviceMotionActive {
            manager.deviceMotionUpdateInterval = 1/40
            manager.startDeviceMotionUpdates(to: .main) { [weak self] motion, error in
                if let attitude = motion?.attitude {
                    self?.xValue = attitude.roll
                    self?.yValue = attitude.pitch
//                    print(attitude.roll)
//                    print("pintch" + "\(attitude.pitch)")
                }
                
//                if let gravity = motion?.gravity {
//                    print(gravity.z)
//                }
            }
        }
    }
    
    func stopMotionUpdates() {
        manager.stopDeviceMotionUpdates()
    }
}

