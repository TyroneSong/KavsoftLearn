//
//  ForgotPassword.swift
//  LoginKit
//
//  Created by 宋璞 on 2023/8/7.
//

import SwiftUI

struct ForgotPassword: View {
    @Binding var showResetView: Bool
    // MARK: - View Properties
    @State private var emailID: String = ""
    /// Environment Properties
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15, content: {
            /// Back Button
            Button(action: {
                dismiss()
            }, label: {
                Image(systemName: "arrow.left")
                    .font(.title2)
                    .foregroundStyle(.gray)
            })
            .padding(.top, 10)
            
            
            Text("Forgot Password")
                .font(.largeTitle)
                .fontWeight(.heavy)
                .padding(.top, 5)
            
            Text("Please enter yout Email ID so that we can send the reet link")
                .font(.callout)
                .fontWeight(.semibold)
                .foregroundColor(.gray)
                .padding(.top, 5)
            
            VStack(spacing: 25) {
                // Custom Text Fields
                CustomTF(sfIcon: "at", hint: "email ID", value: $emailID)
                
                /// Send Link Button
                GradientButton(title: "Send Link", icon: "arrow.right") {
                    /// Code
                    /// After the link sent
                    Task {
                        dismiss()
                        try? await Task.sleep(for: .seconds(0))
                        /// showing the reset View
                        showResetView = true
                    }
                }
                .hSpacing(.trailing)
                .disableWithOpacity(emailID.isEmpty)
            }
            .padding(.top, 20)
            
        })
        .padding(.vertical, 15)
        .padding(.horizontal, 25)
        /// Since this is going to be a sheet
        .interactiveDismissDisabled()
    }
}

#Preview {
    ContentView()
}
