//
//  CustomSlider.swift
//  StretchySlider
//
//  Created by 宋璞 on 2024/2/19.
//

import SwiftUI

struct CustomSlider: View {
    @Binding var sliderProgress: CGFloat
    var symbol: Symbol?
    var axis: SliderAxis
    var tint: Color
    
    @State private var progress: CGFloat = 0.5
    @State private var dragOffset: CGFloat = .zero
    @State private var lastDragOffset: CGFloat = .zero
    var body: some View {
        GeometryReader {
            let size = $0.size
            let orientationSize = axis == .horizontal ? size.width : size.height
            let progressValue = (max(progress, .zero)) * orientationSize
            
            ZStack(alignment: axis == .horizontal ? .leading : .bottom) {
                Rectangle()
                    .fill(.fill)
                
                Rectangle()
                    .fill(tint)
                    .frame(
                        width: axis == .horizontal ? progressValue :  nil,
                        height: axis == .vertical ? progressValue :  nil
                    )
                
                if let symbol, symbol.display {
                    Image(systemName: symbol.icon)
                        .font(symbol.font)
                        .foregroundStyle(symbol.tint)
                        .padding(symbol.padding)
                        .frame(width: size.width, height: size.height, alignment: symbol.alignment)
                }
            }
            .clipShape(.rect(cornerRadius: 15))
            .contentShape(.rect(cornerRadius: 15))
            .optionalSizingModifiers(
                axis: axis,
                size: size,
                progress: progress,
                orientationSize: orientationSize
            )
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged {
                        let translation = $0.translation
                        let movement = (axis == .horizontal ? translation.width : -translation.height) + lastDragOffset
                        dragOffset = movement
                        calculateProgress(orientationSize: orientationSize)
                    }
                    .onEnded({ _ in
                        withAnimation(.smooth) {
                            dragOffset = dragOffset > orientationSize ? orientationSize : (dragOffset < 0 ? 0 : dragOffset)
                            calculateProgress(orientationSize: orientationSize)
                        }
                        lastDragOffset = dragOffset
                    })
            )
            .frame(
                width: size.width,
                height: size.height,
                alignment: axis == .vertical ? (progress < 0 ? .top : .bottom) : ( progress < 0 ? .trailing : .leading)
            )
            .onChange(of: sliderProgress, initial: true) { oldValue, newValue in
                guard sliderProgress != progress, (sliderProgress > 0 && sliderProgress < 1) else { return }
                progress = max(min(sliderProgress, 1.0), 0)
                dragOffset = progress * orientationSize
                lastDragOffset = dragOffset
            }
            .onChange(of: axis) { oldValue, newValue in
                dragOffset = progress * orientationSize
                lastDragOffset = dragOffset
            }
        }
        .onChange(of: progress) { oldValue, newValue in
            sliderProgress = max(min(progress, 1.0), 0.0)
        }
    }
    
    
    /// Calculation Progress
    private func calculateProgress(orientationSize: CGFloat) {
        let topAndTrailingExcessOffset = orientationSize + (dragOffset - orientationSize) * 0.15
        let bottomAndLeadingExcessOffset = dragOffset < 0 ? (dragOffset * 0.15) : dragOffset
        let progress = (dragOffset > orientationSize ? topAndTrailingExcessOffset : bottomAndLeadingExcessOffset) / orientationSize
//        self.progress = progress > 1.2 ? 1.2 : progress
        let limitation: CGFloat = 0.3
        self.progress = progress < 0 ? (-progress > limitation ? -limitation : progress) : (progress > (1.0 + limitation) ? (1.0 + limitation) : progress)
    }
    
    
    /// Symbol Configuration
    struct Symbol {
        var icon: String
        var tint: Color
        var font: Font
        var padding: CGFloat
        var display: Bool = true
        var alignment: Alignment = .bottom
    }
    
    /// Slider Axis
    enum SliderAxis {
        case vertical
        case horizontal
    }
}


fileprivate extension View {
    @ViewBuilder
    func optionalSizingModifiers(axis: CustomSlider.SliderAxis, size: CGSize, progress: CGFloat, orientationSize: CGFloat) -> some View {
        let topAndTrailingScale = 1 - (progress - 1) * 0.25
        let bottomAndLeadingScale = 1 + (progress) * 0.25
        
        self
            .frame(
                width: axis == .horizontal && progress < 0 ? size.width + (-progress * size.width) : nil,
                height: axis == .vertical && progress < 0 ? size.height + (-progress * size.height) : nil
            )
            .scaleEffect(
                x: axis == .vertical ? (progress > 1 ? topAndTrailingScale : (progress < 0 ? bottomAndLeadingScale : 1)) : 1,
                y: axis == .horizontal ? (progress > 1 ? topAndTrailingScale : (progress < 0 ? bottomAndLeadingScale : 1)) : 1,
                anchor: axis == .horizontal ? (progress < 0 ? .trailing : .leading) : (progress < 0 ? .top : .bottom)
            )
    }
}

#Preview {
    ContentView()
}
