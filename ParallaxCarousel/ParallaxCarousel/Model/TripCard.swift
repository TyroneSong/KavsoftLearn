//
//  TripCard.swift
//  ParallaxCarousel
//
//  Created by 宋璞 on 2023/8/14.
//

import SwiftUI


/// Trip Cards Model
struct TripCard: Identifiable, Hashable {
    
    var id: UUID = .init()
    var title: String
    var subTitle: String
    var image: String
}

/// Sample Cards
var tripCards: [TripCard] = [
    .init(title: "蓝天", subTitle: "白云", image: "Pic1"),
    .init(title: "蘑菇", subTitle: "绿草", image: "Pic2"),
    .init(title: "马", subTitle: "草原", image: "Pic3"),
]
