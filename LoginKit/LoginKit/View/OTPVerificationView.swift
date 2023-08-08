//
//  OTPVerificationView.swift
//  AutoOtpTF
//
//  Created by 宋璞 on 2023/8/7.
//

import SwiftUI

struct OTPVerificationView: View {
    
    // MARK: - View Properties
    @Binding var otpText: String
    /// Keyboard State
    @FocusState private var isKeyboardShowing: Bool
        
    var body: some View {
        
        HStack(spacing: 0) {
            ForEach(0 ..< 6, id: \.self) { index in
                OTPTextBox(index)
            }
        }
        .background(content: {
            TextField("", text: $otpText.limit(6))
                .keyboardType(.numberPad)
                /// To Show the most recent one-time code from message
                .textContentType(.oneTimeCode)
                /// Hiding it out
                .frame(width: 1, height: 1)
                .opacity(0.001)
                .blendMode(.screen)
                .focused($isKeyboardShowing)
        })
        .contentShape(Rectangle())
        .onTapGesture {
            isKeyboardShowing.toggle()
        }
        .padding(.all)
        .frame(maxHeight: .infinity, alignment: .top)
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                Button("Done") {
                    isKeyboardShowing.toggle()
                }
                .frame(maxWidth: .infinity, alignment: .trailing )
            }
        }
    }
    
    // MARK: - OTP Text Box
    @ViewBuilder
    func OTPTextBox(_ index: Int) -> some View {
        ZStack {
            if otpText.count > index {
                // Finding Char At Index
                let startIndex = otpText.startIndex
                let charIndex = otpText.index(startIndex, offsetBy: index)
                let charToString = String(otpText[charIndex])
                Text(charToString)
            } else {
                Text(" ")
            }
        }
        .frame(width: 45, height: 45)
        .background {
            /// Highligting Current Active Box
            let status = (isKeyboardShowing && otpText.count == index)
            RoundedRectangle(cornerRadius: 6, style: .continuous)
                .strokeBorder(status ? .blue : .gray, lineWidth: status ? 1 : 0.5)
                /// Animation
                .animation(.easeInOut(duration: 0.4), value: status)
                
        }
        .frame(maxWidth: .infinity)
    }
}

struct OTPVerificationView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



// MARK: - Binding <String> Extension
extension Binding where Value == String {
    func limit(_ length: Int) -> Self {
        if self.wrappedValue.count > length {
            DispatchQueue.main.async {
                self.wrappedValue = String(self.wrappedValue.prefix(length))
            }
        }
        return self
    }
}
