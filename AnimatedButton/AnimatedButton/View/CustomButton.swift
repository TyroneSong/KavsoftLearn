//
//  CustomButton.swift
//  AnimatedButton
//
//  Created by 宋璞 on 2023/8/17.
//

import SwiftUI

struct CustomButton<ButtonContent: View>: View {
    var buttonTint: Color = .white
    var content: () -> ButtonContent
    /// Action
    var action: () async -> TaskStatus
    
    // MARK: - View Properties
    @State private var isLoading: Bool = false
    @State private var taskStatus: TaskStatus = .idea
    @State private var isFailed: Bool = false
    @State private var wiggle: Bool = false
    
    // MARK: - Popup Properties
    @State private var showPopup: Bool = false
    @State private var popupMessage: String = ""
    
    var body: some View {
        Button(action: {
            isLoading = true
            Task {
                let tastStatus = await action()
                switch tastStatus {
                case .idea:
                    isFailed = false
                case .failed(let errStr):
                    isFailed = true
                    popupMessage = errStr
                case .success:
                    isFailed = false
                }
                
                self.taskStatus = tastStatus
                if isFailed {
                    try? await Task.sleep(for: .seconds(0))
                    wiggle.toggle()
                }
                try? await Task.sleep(for: .seconds(0.8))
                if isFailed {
                    showPopup = true
                }
                self.taskStatus = .idea
                isLoading = false
            }
            
        }, label: {
            content()
                .padding(.horizontal, 30)
                .padding(.vertical, 12)
                .opacity(isLoading ? 0 : 1)
                .lineLimit(1)
                .frame(width: isLoading ? 50 : nil, height: isLoading ? 50 : nil)
                .background(Color(taskStatus == .idea ? buttonTint : taskStatus == .success ? .green : .red).shadow(.drop(color: .black.opacity(0.15), radius: 6)), in: .capsule)
                .overlay{
                    if isLoading && taskStatus == .idea {
                        ProgressView()
                    }
                }
                .overlay {
                    if taskStatus != .idea {
                        Image(systemName: isFailed ? "exclamationmark" : "checkmark")
                            .font(.title2.bold())
                            .foregroundStyle(.white)
                    }
                }
                .wiggle(wiggle)
        })
        .disabled(isLoading)
        .popover(isPresented: $showPopup, content: {
            Text(popupMessage)
                .font(.caption)
                .foregroundStyle(.gray)
                .padding(.horizontal, 10)
                .presentationCompactAdaptation(.popover)
        })
        .animation(.snappy, value: isLoading)
        .animation(.snappy, value: taskStatus)
    }
}

extension ButtonStyle where Self == OpacityLessButtonStyle {
    static var opacityLess: Self {
        Self()
    }
}

struct OpacityLessButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
    }
}


/// Wiggle Extension
extension View {
    @ViewBuilder
    func wiggle(_ animate: Bool) -> some View {
        self
            .keyframeAnimator(initialValue: CGFloat.zero, trigger: animate) { view, value in
                view
                    .offset(x: value)
            } keyframes: { _ in
                KeyframeTrack {
                    CubicKeyframe(0, duration: 0.1)
                    CubicKeyframe(-5, duration: 0.1)
                    CubicKeyframe(5, duration: 0.1)
                    CubicKeyframe(-5, duration: 0.1)
                    CubicKeyframe(5, duration: 0.1)
                    CubicKeyframe(-5, duration: 0.1)
                    CubicKeyframe(5, duration: 0.1)
                    CubicKeyframe(0, duration: 0.1)
                }
            }

    }
}

enum TaskStatus: Equatable {
    case idea
    case failed(String)
    case success
}

#Preview {
    ContentView()
}
