//
//  ContentView.swift
//  DraggableMapPin
//
//  Created by 宋璞 on 2024/2/21.
//

import SwiftUI
import MapKit

struct ContentView: View {
    // MARK: - View Properties ⚡️
    @State private var camera: MapCameraPosition = .region(.init(center: .applePark, span: .initialSpan))
    @State private var coordinate: CLLocationCoordinate2D = .applePark
    @State private var mapSpan: MKCoordinateSpan = .initialSpan
    @State private var annotationTitle: String = ""
    // MARK: - View Properties ⚡️
    @State private var updatesCamera: Bool = false
    @State private var displaysTitle: Bool = false
    var body: some View {
        MapReader { proxy in
            Map(position: $camera) {
                // Custom Annotation View
                Annotation(displaysTitle ? annotationTitle : "", coordinate: coordinate) {
                    DraggablePin(proxy: proxy, coordinate: $coordinate) { coordinate in
                        findCoordinateName()
                        guard updatesCamera else { return }
                        // Optional: Updating Camera Position, When Coordinate Changes
                        let newRegion = MKCoordinateRegion(
                            center: coordinate,
                            span: mapSpan
                        )
                        
                        withAnimation(.snappy) {
                            camera = .region(newRegion)
                        }
                    }
                }
            }
            .onMapCameraChange(frequency: .continuous) { ctx in
                mapSpan = ctx.region.span
            }
            .safeAreaInset(edge: .bottom, content: {
                HStack(spacing: 0) {
                    Toggle("Updates Camera", isOn: $updatesCamera)
                        .frame(width: 180)
                    
                    Spacer(minLength: 0)
                    
                    Toggle("Displays Title", isOn: $displaysTitle)
                        .frame(width: 150)
                }
                .textScale(.secondary)
                .padding(15)
                .background(.ultraThinMaterial)
            })
            .onAppear(perform: findCoordinateName)
        }
    }
    
    /// Finds name for current location coordinates
    func findCoordinateName() {
        annotationTitle = ""
        Task {
            let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            let geoDecoder = CLGeocoder()
            if let name = try? await geoDecoder.reverseGeocodeLocation(location).first?.name {
                annotationTitle = name
            }
        }
    }
}

#Preview {
    ContentView()
}


/// Custom Draggable Pin Annotation
struct DraggablePin: View {
    var tint: Color = .red
    var proxy: MapProxy
    @Binding var coordinate: CLLocationCoordinate2D
    var onCoordinateChange: (CLLocationCoordinate2D) -> ()
    // MARK: - View Properties ⚡️
    @State private var isActive: Bool = false
    @State private var translation: CGSize = .zero
    var body: some View {
        GeometryReader {
            let frame = $0.frame(in: .global)
            
            Image(systemName: "mappin")
                .font(.title)
                .foregroundStyle(tint)
                .animation(.snappy, body: { content in
                    content
                        // Scaling on Active
                        .scaleEffect(isActive ? 1.3 : 1, anchor: .bottom)
                })
                .frame(width: frame.width, height: frame.height)
                .onChange(of: isActive, initial: false) { oldValue, newValue in
                    let position = CGPoint(x: frame.midX, y: frame.midY)
                    // Converting Position into Location Coordinate using Map Proxy
                    if let coordinate = proxy.convert(position, from: .global), !newValue {
                        // Updating Coordinate base on translation and resetting translation to zero
                        self.coordinate = coordinate
                        translation = .zero
                        onCoordinateChange(coordinate)
                    }
                }
                
        }
        .frame(width: 30, height: 30)
        .contentShape(.rect)
        .offset(translation)
        .gesture(
            LongPressGesture(minimumDuration: 0.15)
                .onEnded {
                    isActive = $0
                }
                .simultaneously(with:
                    DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        if isActive { translation = value.translation }
                    }
                    .onEnded { value in
                        if isActive { isActive = false }
                    }
                )
        )
    }
}



// MARK: - Static Values ⚡️

extension MKCoordinateSpan {
    /// Init Span
    static var initialSpan: MKCoordinateSpan {
        return .init(latitudeDelta: 0.05, longitudeDelta: 0.05)
    }
}

extension CLLocationCoordinate2D {
    /// Apple Park
    static var applePark: CLLocationCoordinate2D {
        return .init(latitude: 37.334606, longitude: -122.009102)
    }
}
