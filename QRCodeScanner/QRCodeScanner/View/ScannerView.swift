//
//  ScannerView.swift
//  QRCodeScanner
//
//  Created by 宋璞 on 2023/8/2.
//

import SwiftUI
import AVKit

struct ScannerView: View {
    
    // MARK: - QR Code Scanner Properties
    @State private var isScanning: Bool = false
    @State private var session: AVCaptureSession = .init()
    @State private var cameraPermission: Permission = .idle
    
    // MARK: - Scanner AV Output
    @State private var qrOutput: AVCaptureMetadataOutput = .init()
    
    // MARK: - Error Properties
    @State private var errorMsg: String = ""
    @State private var showError: Bool = false
    @Environment(\.openURL) private var openURL
    
    // MARK: - Camera QR Output Delegate
    @StateObject private var qrDelegate = QRScannerDelegate()
    
    // MARK: - Scanned Code
    @State private var scannedCode: String = ""
    
    // MARK: - Device Orientation
    @State private var orientation: UIDeviceOrientation = UIDevice.current.orientation
    
    var body: some View {
        VStack(spacing: 8) {
            Button(action: {}) {
                Image(systemName: "xmark")
                    .font(.title3)
                    .foregroundColor(Color("Blue"))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("Place the QR Code inside the area")
                .font(.title3)
                .foregroundColor(.black.opacity(0.8))
                .padding(.top, 20)
            
            Text("Scanning will Start automatically")
                .font(.callout)
                .foregroundColor(.gray)
            
            Spacer()
            
            GeometryReader {
                let size = $0.size
                let sqareWidth = min(size.width, 300)
                
                ZStack {
                    CameraView(frameSize: CGSize(width: sqareWidth, height: sqareWidth), session: $session, orientation: $orientation)
                        .cornerRadius(4)
                        .scaleEffect(0.97)
                        .onRotate {
                            if session.isRunning {
                                orientation = $0
                            }
                        }
                    
                    ForEach(0...4, id: \.self) { index in
                        let rotation = Double(index) * 90
                        
                        RoundedRectangle(cornerRadius: 2, style: .circular)
                            .trim(from: 0.61, to: 0.64)
                            .stroke(Color("Blue"), style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
                            .rotationEffect(.init(degrees: rotation))
                    }
                }
                /// Sqaure Shape
                .frame(width: sqareWidth, height: sqareWidth)
                /// Scanner Animation
                .overlay(alignment: .top) {
                    Rectangle()
                        .fill(Color("Blue"))
                        .frame(height: 2.5)
                        .shadow(color: .black.opacity(0.8), radius: 8, x: 0,y: isScanning ?  15 : -15)
                        .offset(y: isScanning ? sqareWidth : 0)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .padding(.horizontal, 15)
            
            Spacer(minLength: 15)
            
            Button {
                if !session.isRunning && cameraPermission == .approved {
                    reactivateCamera()
                    activateScannerAnimation()
                }
            } label: {
                Image(systemName: "qrcode.viewfinder")
                    .font(.largeTitle)
                    .foregroundColor(.gray)
            }
            
            Spacer(minLength: 45)
            
        }
        .padding(15)
        .onAppear(perform: checkCameraPermission)
        .onDisappear {
            session.stopRunning()
        }
        .alert(errorMsg, isPresented: $showError, actions: {
            if cameraPermission == .denied {
                Button("Setttings") {
                    let settingsString = UIApplication.openSettingsURLString
                    if let settingsURL = URL(string: settingsString) {
                        openURL(settingsURL)
                    }
                }
                
                Button("Cancle", role: .cancel) {
                    
                }
            }
        })
        .onChange(of: qrDelegate.scannedCode, perform: { newValue in
            if let code = newValue {
                scannedCode = code
                session.stopRunning()
                deActivateScannerAnimation()
                qrDelegate.scannedCode = nil
                presentError(scannedCode)
            }
        })
        .onChange(of: session.isRunning) { newValue in
            if newValue {
                orientation = UIDevice.current.orientation
            }
        }
    }
    
    
    func reactivateCamera() {
        DispatchQueue.global(qos: .background).async {
            session.startRunning()
        }
    }
    
    func activateScannerAnimation() {
        withAnimation(.easeInOut(duration: 1.85).delay(0.1).repeatForever(autoreverses: true)) {
            isScanning = true
        }
    }
    
    func deActivateScannerAnimation() {
        withAnimation(.easeInOut(duration: 0.85)) {
            isScanning = false
        }
    }
    
    func checkCameraPermission() {
        Task {
            switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized:
                cameraPermission = .approved
                if session.inputs.isEmpty {
                    // New Camera
                    setupCamera()
                } else {
                    // Re Activate
                    reactivateCamera()
                }
            case .notDetermined:
                if await AVCaptureDevice.requestAccess(for: .video) {
                    cameraPermission = .approved
                    setupCamera()
                } else {
                    cameraPermission = .denied
                    presentError("Plase Provide Access to Camera For scanning codes ")
                }
            case .denied, .restricted:
                cameraPermission = .denied
                presentError("Plase Provide Access to Camera For scanning codes")
            default: break
            }
        }
    }
    
    func setupCamera() {
        do {
            // Finde Back Camera
            guard let device = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInTripleCamera], mediaType: .video, position: .back).devices.first else {
                presentError("UNKNOW DEVICE ERROR")
                return
            }
            
            let maxZoomFactor = device.activeFormat.videoMaxZoomFactor
            let desiredZoomFactor: CGFloat = 3.0
            if maxZoomFactor >= desiredZoomFactor {
                do {
                    try device.lockForConfiguration()
                    device.videoZoomFactor = desiredZoomFactor
                    device.unlockForConfiguration()
                } catch {
                    print("Error setting zoom level: \(error)")
                }
            }
            
            // Camera Inout
            let input = try AVCaptureDeviceInput(device: device)
            guard session.canAddInput(input), session.canAddOutput(qrOutput) else {
                presentError("UNKOWN INPUT/OUTPUT ERROR")
                return
            }
            
            session.beginConfiguration()
            
            session.addInput(input)
            session.addOutput(qrOutput)
            
            // Setting Output Config to read QR Codes
            qrOutput.metadataObjectTypes = [.qr, .aztec, .gs1DataBarExpanded, .ean13, .ean8, .gs1DataBar, .gs1DataBarLimited, .microQR]
            // Add delegate
            qrOutput.setMetadataObjectsDelegate(qrDelegate, queue: .main)
            
            session.commitConfiguration()
            
            DispatchQueue.global(qos: .background).async {
                session.startRunning()
            }
            
            activateScannerAnimation()
            
        } catch  {
            presentError(error.localizedDescription)
        }
    }
    
    /// Presenting Error
    func presentError(_ message: String) {
        errorMsg = message
        showError.toggle()
    }
}

struct ScannerView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
