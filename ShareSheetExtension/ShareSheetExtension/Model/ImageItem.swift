//
//  ImageItem.swift
//  ShareSheetExtension
//
//  Created by 宋璞 on 2024/1/29.
//

import SwiftUI
import SwiftData

@Model
class ImageItem {
    @Attribute(.externalStorage) // It's recommended to store Images and large data in external storeage
    var data: Data
    
    init(data: Data) {
        self.data = data
    }
}
