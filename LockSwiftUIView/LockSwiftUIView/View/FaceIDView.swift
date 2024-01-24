//
//  FaceIDView.swift
//  LockSwiftUIView
//
//  Created by 宋璞 on 2024/1/23.
//

import SwiftUI
import LocalAuthentication

struct FaceIDView: View {
    
    @State private var isUnlocked = false
    
    var body: some View {
        VStack {
            
            
            
            if self.isUnlocked {
                Text("Unlocked")
                    .foregroundColor(.green)
            } else {
                Text("Locked")
                    .foregroundColor(.red)
                    .onTapGesture {
                        switch self.biometryType {
                        case .faceID:
                            print("Face ID")
                        case .touchID:
                            print("Touch ID")
                        case .none:
                            print("None")
                        case .opticID:
                            print("optic ID")
                        @unknown default:
                            print("unknown")
                        }
                    }
            }
        }
        .font(.largeTitle)
        .onAppear(perform: authenticate)
    }
    
    
    private var biometryType: LABiometryType {
        var error: NSError?
        let context = LAContext()
        
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            return .none
        }
         
        return context.biometryType
    }
    
    
    
    private func authenticate() {
        let context = LAContext()
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            
            Task {
                let reason = "We need to unlock your data."
                if let res = try? await context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason), res {
                    isUnlocked = true
                }
            }
        }
    }
}

#Preview {
    FaceIDView()
}
