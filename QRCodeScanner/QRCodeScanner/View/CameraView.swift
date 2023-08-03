//
//  CameraView.swift
//  QRCodeScanner
//
//  Created by 宋璞 on 2023/8/2.
//

import SwiftUI
import AVKit

struct CameraView: UIViewRepresentable {
    
    var frameSize: CGSize
    @Binding var session: AVCaptureSession
    @Binding var orientation: UIDeviceOrientation
    
    func makeUIView(context: Context) -> UIView {
        let view = UIViewType(frame: CGRect(origin: .zero, size: frameSize))
        view.backgroundColor = .clear
        
        let camerLayer = AVCaptureVideoPreviewLayer(session: session)
        camerLayer.frame = .init(origin: .zero, size: frameSize)
        camerLayer.videoGravity = .resizeAspectFill
        camerLayer.masksToBounds = true
        view.layer.addSublayer(camerLayer)
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        if let layer = uiView.layer.sublayers?.first(where: { $0 is AVCaptureVideoPreviewLayer }) as? AVCaptureVideoPreviewLayer {
            switch orientation {
            case .portrait: layer.setAffineTransform(.init(rotationAngle: 0))
            case .landscapeLeft: layer.setAffineTransform(.init(rotationAngle: -.pi/2))
            case .landscapeRight: layer.setAffineTransform(.init(rotationAngle: .pi/2))
            case .portraitUpsideDown: layer.setAffineTransform(.init(rotationAngle: .pi))
            default: break
            }
        }
    }
}
