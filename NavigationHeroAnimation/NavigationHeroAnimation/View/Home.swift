//
//  Home.swift
//  RadialView
//
//  Created by 宋璞 on 2023/7/26.
//

import SwiftUI


struct Home: View {
    // View Properties
    @Binding var selectedProFile: Profile?
    @Binding var pushView: Bool
    
    var body: some View {
        List {
            ForEach(Profile.files) { profile in
                Button(action: {
                    selectedProFile = profile
                    pushView.toggle()
                }, label: {
                    HStack(spacing: 15, content: {
                        Color.clear
                            .frame(width: 60, height: 60)
                        // Source View Anchor
                            .anchorPreference(key: MAnchorKey.self, value: .bounds, transform: { anchor in
                                return [profile.id: anchor]
                            })
                        
                        VStack(alignment: .leading, spacing: 2, content: {
                            Text(profile.userName)
                                .fontWeight(.semibold)
                                .foregroundStyle(.black)
                            Text(profile.lastMsg)
                                .font(.callout)
                                .foregroundStyle(.gray)
                        })
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text(profile.lastActive)
                            .font(.caption)
                            .foregroundStyle(.gray)
                    })
                    .contentShape(.rect)
                })
            }
        }
        .overlayPreferenceValue(MAnchorKey.self, { value in
            GeometryReader(content: { geometry in
                ForEach(Profile.files) { profile in
                    /// Fetching Each Profile Image View using the Profile ID
                    /// Hiding the Currently Tapped View
                    if let anchor = value[profile.id], selectedProFile?.id != profile.id {
                        let rect = geometry[anchor]
                        ImageView(profile: profile, size: rect.size)
                            .offset(x: rect.minX, y: rect.minY)
                            .allowsHitTesting(false)
                    }
                }
            })
        })
    }
}

struct DetailView: View {
    
    @Binding var selectedProfile: Profile?
    @Binding var pushView: Bool
    @Binding var hideView: (Bool, Bool)
    
    var body: some View {
        if let selectedProfile {
            VStack {
                GeometryReader(content: { geometry in
                    let size = geometry.size
                    
                    VStack {
                        if hideView.0 {
                            ImageView(profile: selectedProfile, size: size)
                                /// Custom Close Button
                                .overlay(alignment: .top) {
                                    ZStack {
                                        Button(action: {
                                            hideView.0 = false
                                            hideView.1 = false
                                            pushView = false
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                                self.selectedProfile = nil
                                            }
                                        }, label: {
                                            Image(systemName: "xmark")
                                                .foregroundStyle(.white)
                                                .padding(20)
                                                .background(.black, in: .circle)
                                                .contentShape(.circle)
                                        })
                                        .padding(15)
                                        .padding(.top, 40)
                                        .frame(maxWidth: .infinity, maxHeight:.infinity, alignment: .topTrailing)
                                        
                                        Text(selectedProfile.userName)
                                            .font(.title.bold())
                                            .foregroundStyle(.black)
                                            .padding(15)
                                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                                    }
                                    .opacity(hideView.1 ? 1 : 0)
                                    .animation(.snappy, value: hideView.1)
                                }
                                .onAppear(perform: {
                                    // Removing the Animated View once the Animation is Finished
                                    DispatchQueue.main.asyncAfter(deadline: .now()) {
                                        hideView.1 = true
                                    }
                                })
                        } else {
                            Color.clear
                        }
                    }
                    // Destination View Anchor
                    .anchorPreference(key: MAnchorKey.self
                                      , value: .bounds, transform: { anchor in
                        return [selectedProfile.id: anchor]
                    })
                })
                .frame(height: 400)
                .ignoresSafeArea()
                
                Spacer(minLength: 0)
            }
            .toolbar(hideView.0 ? .hidden : .visible, for: .navigationBar)
            .onAppear(perform: {
                // Removing the Animated View once the Animation is Finished
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.45) {
                    hideView.0 = true
                }
            })
        }
    }
}

struct ImageView: View {
    var profile: Profile
    var size: CGSize
    
    var body: some View {
        Image(profile.profilePicture)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: size.width, height: size.height)
            /// Linear Gradient at Bottom
            .overlay(content: {
                LinearGradient(colors: [
                    .clear,
                    .clear,
                    .clear,
                    .white.opacity(0.1),
                    .white.opacity(0.5),
                    .white.opacity(0.9),
                    .white
                ], startPoint: .top, endPoint: .bottom)
                .opacity(size.width > 60 ? 1 : 0)
            })
            .clipShape(.rect(cornerRadius: size.width > 60 ? 0 : 30))
    }
}

#Preview {
    ContentView()
}
