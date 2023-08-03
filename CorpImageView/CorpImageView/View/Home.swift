//
//  Home.swift
//  CorpImageView
//
//  Created by 宋璞 on 2023/7/25.
//

import SwiftUI

struct Home: View {
    
    /// - View Properties
    @State private var showPicker: Bool = false
    @State private var croppedImage: UIImage?
    
    var body: some View {
        NavigationStack {
            VStack {
                if let croppedImage {
                    Image(uiImage: croppedImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 300, height: 400)
                } else {
                    Text("Crop Image Picker")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            .navigationTitle("Crop Image Picker")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showPicker.toggle()
                    } label: {
                        Image(systemName: "photo.on.rectangle.angled")
                            .font(.callout)
                    }
                    .tint(.black)

                }
            }
            .cropImagePicker(options: [.circle, .rectangle, .square, .custom(CGSize(width: 200, height: 200))], show: $showPicker, croppedImage: $croppedImage)
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
