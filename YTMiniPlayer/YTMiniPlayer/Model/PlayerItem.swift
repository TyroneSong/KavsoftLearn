//
//  PlayerItem.swift
//  YTMiniPlayer
//
//  Created by 宋璞 on 2024/2/26.
//

import SwiftUI


let dummyDescription: String = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book."


struct PlayerItem: Identifiable, Equatable {
    let id: UUID = .init()
    var title: String
    var author: String
    var image: String
    var description: String = dummyDescription
}

///Sample Data
var items: [PlayerItem] = [
    .init(
        title: "Apple Vision Pro - Unboxing, Review and demos!",
        author: "iJsutine",
        image: "Pic 1"
    ),
    .init(
        title: "Hero Effet - SwiftUI",
        author: "kavsoft",
        image: "Pic 2"
    ),
    .init(
        title: "What Apple Vision Pro is really like",
        author: "iJsutine",
        image: "Pic 3"
    ),
    .init(
        title: "Draggable Map pin",
        author: "kavsoft",
        image: "Pic 4"
    ),
    .init(
        title: "Maps Bottom Sheet",
        author: "kavsoft",
        image: "Pic 5"
    ),
]
