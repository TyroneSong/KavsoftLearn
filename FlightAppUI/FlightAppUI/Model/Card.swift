//
//  Card.swift
//  FlightAppUI
//
//  Created by 宋璞 on 2023/8/2.
//

import SwiftUI

struct Card: Identifiable {
    var id: UUID = .init()
    var cardImage: String
}

var sampleCards: [Card] = [
    .init(cardImage: "Card1"),
    .init(cardImage: "Card2"),
    .init(cardImage: "Card3"),
    .init(cardImage: "Card4"),
    .init(cardImage: "Card5")
]
