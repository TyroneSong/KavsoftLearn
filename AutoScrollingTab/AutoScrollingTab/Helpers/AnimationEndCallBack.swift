//
//  AnimationEndCallBack.swift
//  AutoScrollingTab
//
//  Created by 宋璞 on 2023/8/8.
//

import SwiftUI

 
struct AnimationState {
    var progress: CGFloat = 0
    var status: Bool = false
    
    mutating func startAnimation() {
        progress = 1.0
        status = true
    }
    
    mutating func reset() {
        progress = .zero
        status = false
    }
}


struct AnimationEndCallBack<Value: VectorArithmetic>: Animatable, ViewModifier {
    var animatableData: Value {
        didSet {
            checkIfAnimationFinished()
        }
    }
    
    var endValue: Value
    var onEnd: () -> Void
    
    init(endValue: Value, onEnd: @escaping () -> Void) {
        self.endValue = endValue
        self.animatableData = endValue
        self.onEnd = onEnd
    }
    
    func body(content: Content) -> some View {
        content
    }
    
    func checkIfAnimationFinished() {
        print(animatableData)
        if animatableData == endValue {
            DispatchQueue.main.async {
                onEnd()
            }
        }
    }

}
