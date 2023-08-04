//
//  TagLayout.swift
//  TagView
//
//  Created by 宋璞 on 2023/8/4.
//

import SwiftUI

struct TagLayout: Layout {
    
    /// Layout Properties
    var alignment: Alignment = .center
    /// Both Horizontal & Vertical
    var spacing: CGFloat = 10
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let maxWidth = proposal.width ?? 0
        var height: CGFloat = 0
        let rows = generationRows(maxWidth, proposal, subviews)
        
        for (index, row) in rows.enumerated() {
            // Finding max Height in each row and adding it to the View's Total Height
            if index == (rows.count - 1) {
                height += row.maxHeight(proposal)
            } else {
                height += row.maxHeight(proposal) + spacing
            }
        }
        
        return .init(width: maxWidth, height: height)
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        // Placing View
        var origin = bounds.origin
        let maxWidth = bounds.width
        let rows = generationRows(maxWidth, proposal, subviews)
        
        for row in rows {
            
            // Changing Origin X based on Alignments
            let leading: CGFloat = bounds.maxX - maxWidth
            let trailing = bounds.maxX - (row.reduce(CGFloat.zero) { partialResult, view in
                let width = view.sizeThatFits(proposal).width
                
                
                if view == row.last {
                    return partialResult + width
                }
                return partialResult + width + spacing
            })
            let center = (trailing + leading) / 2
            
            // Reset Origin X
            origin.x = (alignment == .leading ? leading : alignment == .trailing ? trailing : center)
            
            for view in row {
                let viewSize = view.sizeThatFits(proposal)
                view.place(at: origin, proposal: proposal)
                
                // Update Origin X
                origin.x += (viewSize.width + spacing)
            }
            
            // Update Origin Y
            origin.y += (row.maxHeight(proposal) + spacing)
        }
    }
    
    /// Generating Rows based on Available Size
    func generationRows(_ maxWidth: CGFloat, _ proposal: ProposedViewSize, _ subViews: Subviews) -> [[LayoutSubviews.Element]] {
        var row: [LayoutSubviews.Element] = []
        var rows: [[LayoutSubviews.Element]] = []
        
        /// Origin
        var origin = CGRect.zero.origin
        
        for view in subViews {
            let viewSize = view.sizeThatFits(proposal)
            
            // Pushing To New Row
            if (origin.x + viewSize.width + spacing) > maxWidth {
                rows.append(row)
                row.removeAll()
                // Reseting X Origin since it need to start frome Left or Right
                origin.x = 0
                row.append(view)
                // Updating Origin X
                origin.x += (viewSize.width + spacing)
            } else {
                // add Same Row
                row.append(view)
                // Updating Origin X
                origin.x += (viewSize.width + spacing)
            }
        }
        
        // Checking For Any exhaust row
        if !row.isEmpty {
            rows.append(row)
            row.removeAll()
        }
        
        return rows
    }
    
}

extension [LayoutSubviews.Element] {
    func maxHeight(_ proposal: ProposedViewSize) -> CGFloat {
        return self.compactMap { view in
            return view.sizeThatFits(proposal).height
        }.max() ?? 0
    }
}

#Preview {
    ContentView()
}
