//
//  ContentView.swift
//  DragImagePicker
//
//  Created by 宋璞 on 2023/8/23.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack {
                ImagePicker(title: "Drag & Drop", subTitle: "Tap to add an Image", systemImage: "square.and.arrow.up", tint: .blue) { image in
                    print(image)
                }
                .frame(maxWidth: 300, maxHeight: 250)
                .padding(.top, 20)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Image Picker")
        }
    }
}

#Preview {
    ContentView()
}

/// Custom Image Picker
/// Included With Drag & Drop

struct ImagePicker: View {
    var title: String
    var subTitle: String
    var systemImage: String
    var tint: Color
    var onImageChange: (UIImage) -> ()
    
    // MARK: - View Properties
    @State private var showImagePicker: Bool = false
    @State private var photoItem: PhotosPickerItem?
    // MARK: - PreView Image
    @State private var previewImage: UIImage?
    // MARK: - Loading Status
    @State private var isLoading: Bool = false
    var body: some View {
        GeometryReader{
            let size = $0.size
            
            VStack(spacing: 4) {
                Image(systemName: systemImage)
                    .font(.largeTitle)
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                
                Text(title)
                    .font(.callout)
                    .padding(.top, 15)
                
                Text(subTitle)
                    .font(.callout)
                    .foregroundStyle(.gray)
            }
            /// 展示预览图片
            .opacity(previewImage == nil ? 1 : 0)
            .frame(width: size.width, height: size.height)
            .overlay {
                if let previewImage {
                    Image(uiImage: previewImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(15)
                }
            }
            /// 展示 加载 UI
            .overlay {
                if isLoading {
                    ProgressView()
                        .padding(10)
                        .background(.ultraThinMaterial, in: .rect(cornerRadius: 5))
                }
            }
            /// 动画过渡
            .animation(.snappy, value: isLoading)
            .animation(.snappy, value: previewImage)
            /// 实现 Drop 图片
            .dropDestination(for: Data.self, action: { items, location in
                if let firstItem = items.first, let droppedImage = UIImage(data: firstItem) {
                    /// 回调 使用的图片
                    generateImageThumbnail(droppedImage, size)
                    previewImage = droppedImage
                    onImageChange(droppedImage)
                    return true
                }
                return false
            }, isTargeted: { _ in
                
            })
            .onTapGesture {
                showImagePicker.toggle()
            }
            /// 实现 Image Picker 引入的图片
            .photosPicker(isPresented: $showImagePicker, selection: $photoItem)
            .contentShape(.rect)
            /// 图片选择
            .optionalViewModifier { contentView in
                if #available(iOS 17, *) {
                    contentView
                        .onChange(of: photoItem) { oldValue, newValue in
                            if let newValue {
                                extractImage(newValue, size)
                            }
                        }
                } else {
                    contentView
                        .onChange(of: photoItem) { newValue in
                            if let newValue {
                                extractImage(newValue, size)
                            }
                        }
                }
            }
            .background {
                ZStack {
                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                        .fill(tint.opacity(0.08).gradient)
                    
                    
                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                        .stroke(tint, style: .init(lineWidth: 1, dash: [12]))
                        .padding(1)
                }
            }
        }
    }
    
    /// 提取 图片
    func extractImage(_ photoItem: PhotosPickerItem, _ viewSize: CGSize) {
        Task.detached {
            guard let imageData = try? await photoItem.loadTransferable(type: Data.self) else {
                return
            }
            
            // UI 相关放在 主线程
            await MainActor.run {
                if let selectedImage = UIImage(data: imageData) {
                    // 创建 preView
                    generateImageThumbnail(selectedImage, viewSize)
                    
                    // 回调
                    onImageChange(selectedImage)
                }
                
                // 清空 PhotoItem
                self.photoItem = nil
            }
        }
    }
    
    /// 创建缩略图
    func generateImageThumbnail(_ image: UIImage, _ size: CGSize) {
        Task.detached {
            let thumbnailImage = await image.byPreparingThumbnail(ofSize: size)
            // UI 在主线程上 update
            await MainActor.run {
                previewImage = thumbnailImage
            }
        }
    }
}

/// 可选 View Modifier
extension View {
    @ViewBuilder
    func optionalViewModifier<Content: View>(@ViewBuilder content: @escaping (Self) -> Content) -> some View {
        content(self)
    }
}
