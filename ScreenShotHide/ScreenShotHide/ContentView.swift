//
//  ContentView.swift
//  ScreenShotHide
//
//  Created by 宋璞 on 2023/7/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink {
                    ScreenshotPrevenView {
                        GeometryReader {
                            let size = $0.size
                            Image(.cat)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: size.width, height: size.height)
                                .clipShape(.rect(topLeadingRadius: 35, bottomTrailingRadius: 35))
                        }
                        .padding(15)
                        
                    }
                    .navigationTitle("IJJJJ")
                } label: {
                    Text("Show Image")
                }
                
                NavigationLink {
                    List {
                        Section("API Key") {
                            ScreenshotPrevenView {
                                Text("SDDDSDsfsdfs")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        
                        Section("APNS Key") {
                            ScreenshotPrevenView {
                                Text("sdfsd")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                            }
                        }
                    }
                } label: {
                    Text("Show Security key")
                }


            }
            .navigationTitle("My List")
        }
    }
}

#Preview {
    ContentView()
}
