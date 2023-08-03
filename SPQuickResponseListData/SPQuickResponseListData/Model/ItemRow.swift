//
//  ItemRow.swift
//  SPQuickResponseListData
//
//  Created by 宋璞 on 2023/7/31.
//

import SwiftUI

// 满足 ForEach 的 Identifiable 的 需求
//extension Item: Identifiable {}

struct ItemRow: View {
    static var count = 0
    let item: Item
    init(item: Item) {
        self.item = item
        Self.count += 1
        print(Self.count)
    }
    var body: some View {
        Text(item.timestamp!, format: .dateTime)
            .frame(minHeight: 40)
    }
}
