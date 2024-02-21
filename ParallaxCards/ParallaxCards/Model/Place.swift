//
//  Place.swift
//  ParallaxCards
//
//  Created by 宋璞 on 2024/2/21.
//

import SwiftUI

// MARK: - Place Model and Sample Data ⚡️
struct Place: Identifiable, Hashable {
    var id: String = UUID().uuidString
    var placeName: String
    var imageName: String
    var bgName: String
}

var sample_places: [Place] = [
    .init(placeName: "Brazil", imageName: "Rio", bgName: "RioBG"),
    .init(placeName: "France", imageName: "France", bgName: "FranceBG"),
    .init(placeName: "Iceland", imageName: "Iceland", bgName: "IcelandBG")
]
