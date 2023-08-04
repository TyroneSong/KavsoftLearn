//
//  ContentView.swift
//  TagView
//
//  Created by 宋璞 on 2023/8/3.
//

import SwiftUI

struct ContentView: View {
    
    @State private var tags: [String] = ["SwiftUI", "Swift", "iOS", "Xcode", "WWDC", "Android", "Fluttter", "React", "App", "Indie", "Developer", "Object", "C#", "C++", "C", "iPhone", "iWatch", "iPad"]
    @State private var selectedTags: [String] = []
    // Add Matched Geometry Effect
    @Namespace private var animation
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView(.horizontal) {
                HStack(spacing: 12, content: {
                    ForEach(selectedTags, id: \.self) { tag in
                        TagView(tag, .pink, "checkmark")
                            .matchedGeometryEffect(id: tag, in: animation)
                            // Removing from Selected List
                            .onTapGesture {
                                withAnimation(.snappy) {
                                    selectedTags.removeAll(where: { $0 == tag })
                                }
                            }
                    }
                })
                .padding(.horizontal, 15)
                .frame(height: 35)
                .padding(.vertical, 15)
            }
            .scrollClipDisabled(true)
            .scrollIndicators(.hidden)
            .overlay(content: {
                if selectedTags.isEmpty {
                    Text("Select More than 3 Tags")
                        .font(.callout)
                        .foregroundStyle(.gray)
                }
            })
            .background(.white)
            .zIndex(1)
            
            ScrollView(.vertical) {
                TagLayout(alignment: .center, spacing: 10) {
                    ForEach(tags.filter { !selectedTags.contains($0) }, id: \.self) { tag in
                        TagView(tag, .blue, "plus")
                            .matchedGeometryEffect(id: tag, in: animation)
                            .onTapGesture {
                                withAnimation(.snappy) {
                                    selectedTags.insert(tag, at: 0)
                                }
                            }
                    }
                }
                .padding(15)
            }
            .scrollClipDisabled(true)
            .scrollIndicators(.hidden)
            .background(.black.opacity(0.05))
            .zIndex(0)
            
            ZStack {
                Button(action: {}, label: {
                    Text("Continue")
                        .fontWeight(.semibold)
                        .padding(.vertical, 15)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.pink.gradient)
                        )
                })
                /// Disabling until 3 or more tags selected
                .disabled(selectedTags.count < 3)
                .opacity(selectedTags.count < 3 ? 0.5 : 1)
                .padding()
            }
            .background(.white)
            .zIndex(2)
        }
        .preferredColorScheme(.light)
    }
    
    @ViewBuilder
    func TagView(_ tag: String, _ color: Color, _ icon: String) -> some View {
        HStack(spacing: 15, content: {
            Text(tag)
                .font(.callout)
                .fontWeight(.semibold)
            
            Image(systemName: icon)
        })
        .frame(height: 35)
        .foregroundColor(.white)
        .padding(.horizontal, 15)
        .background(
            Capsule()
                .fill(color.gradient)
        )
    }
}

#Preview {
    ContentView()
}
