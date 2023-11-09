//
//  Card.swift
//  CarScroll
//
//  Created by 宋璞 on 2023/11/9.
//

import SwiftUI

struct Card: Identifiable {
    var id: UUID = UUID()
    var bgColor: Color
    var balance: String
}

var cards: [Card] = [
    Card(bgColor: .red, balance: "$125,000"),
    Card(bgColor: .blue, balance: "$25,000"),
    Card(bgColor: .darkOrange, balance: "$25,000"),
    Card(bgColor: .purple, balance: "$5,000"),
]

