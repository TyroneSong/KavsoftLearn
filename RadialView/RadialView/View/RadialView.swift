//
//  RadialView.swift
//  RadialView
//
//  Created by 宋璞 on 2023/7/25.
//

import SwiftUI

/// Custom View
struct RadialLayout<Content: View, Item: RandomAccessCollection, ID: Hashable>: View where Item.Element: Identifiable {
    // Additionally Returning Index and View Size
    var content: (Item.Element, Int, CGFloat) -> Content
    var keyPathID: KeyPath<Item.Element, ID>
    var items: Item
    
    
    // MARK: - View Properties
    var spacing: CGFloat?
    var onIndexChange: (Int) -> Void
    
    // MARK: - Gesture Properties
    @State private var dragRotation: Angle = .zero
    @State private var lastDragRotation: Angle = .zero
    @State private var activeIndex: Int = 0
    
    init(items: Item, id: KeyPath<Item.Element, ID>, spacing: CGFloat? = nil, @ViewBuilder content: @escaping (Item.Element, Int, CGFloat) -> Content, onIndexChange: @escaping (Int) -> Void) {
        self.content = content
        self.onIndexChange = onIndexChange
        self.spacing = spacing
        self.keyPathID = id
        self.items = items
    }
    
    var body: some View {
        GeometryReader { geometry in
            let size = geometry.size
            let width = size.width
            let count = CGFloat(items.count)
            // Applying Spacing
            let spacing: CGFloat = spacing ?? 0
            
            let viewSize = (width - spacing) / (count / 2)
            
            ZStack {
                ForEach(items, id: keyPathID) { item in
                    let index = fetchIndex(item)
                    let rotation = (CGFloat(index) / count) * 360.0
                    
                    content(item, index, viewSize)
                        .rotationEffect(.init(degrees: 90))
                        .rotationEffect(.init(degrees: -rotation))
                        .rotationEffect(-dragRotation)
                        .frame(width: viewSize, height: viewSize)
                        .offset(x: (width - viewSize) / 2)
                        .rotationEffect(.init(degrees: -90))
                        .rotationEffect(.init(degrees: rotation))
                }
            }
            .frame(width: width, height: width)
            // Gestrue
            .contentShape(.rect) // 无法使用呢
            .rotationEffect(dragRotation)
            .gesture(
                DragGesture()
                    .onChanged({ value in
                        let translationX = value.translation.width
                        
                        let progress = translationX / (viewSize * 2)
                        let rotationFraction = 360.0 / count
                        dragRotation = .init(degrees: (rotationFraction * progress) + lastDragRotation.degrees)
                        calculateIndex(count)
                    }).onEnded({ value in
                        let velocityX = 0.0 // value.velocity.width / 15
                        let translationX = value.translation.width + velocityX
                        
                        let progress = (translationX / (viewSize * 2)).rounded()
                        let rotationFraction = 360.0 / count
                        
                        withAnimation(.smooth) {
                            dragRotation = .init(degrees: (rotationFraction * progress) + lastDragRotation.degrees)
                        }
                        
                        lastDragRotation = dragRotation
                        calculateIndex(count)
                    })
            )
        }
    }
    
    /// Calculate The Center Top Index
    func calculateIndex(_ count: CGFloat) {
        var activeIndex = (dragRotation.degrees / 360.0 * count).rounded().truncatingRemainder(dividingBy: count)
        activeIndex = activeIndex == 0 ? 0 : (activeIndex < 0 ? -activeIndex : count - activeIndex)
        self.activeIndex = Int(activeIndex)
        
        // Notifition View
        onIndexChange(self.activeIndex)
    }
    
    /// Fetching Item Index
    func fetchIndex(_ item: Item.Element) -> Int {
        if let index = items.firstIndex(where: {
            $0.id == item.id
        }) as? Int {
            return index
        }
        
        return 0
    }
}

struct RadialView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


