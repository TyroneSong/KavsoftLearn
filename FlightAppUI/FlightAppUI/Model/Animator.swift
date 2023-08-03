//
//  Animator.swift
//  FlightAppUI
//
//  Created by 宋璞 on 2023/8/3.
//

import SwiftUI

/// Animator
/// 监听所有动画属性
class Animator: ObservableObject {
    /// Aniation Properties
    @Published var startAnimation: Bool = false
    /// Initial Plane Postion
    @Published var initialPlanePosition: CGRect = .zero
    /// Payment Status
    @Published var currentPaymentStatus: PaymentStatus = .initated
    /// Rings Status
    @Published var ringAnimation: [Bool] = [false, false]
    /// Loading Status
    @Published var showLoadingView: Bool = false
    /// Cloud View Status
    @Published var showClouds: Bool = false
    /// Final View Status
    @Published var showFinalView: Bool = false
}


// MARK: - Anchor Preference Key

struct RectKey: PreferenceKey {
    static var defaultValue: [String: Anchor<CGRect>] = [:]
    static func reduce(value: inout [String : Anchor<CGRect>], nextValue: () -> [String : Anchor<CGRect>]) {
        value.merge(nextValue()) { $1 }
    }
}
