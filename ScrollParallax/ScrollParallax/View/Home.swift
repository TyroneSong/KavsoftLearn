//
//  Home.swift
//  ScrollParallax
//
//  Created by 宋璞 on 2024/1/5.
//

import SwiftUI

struct Home: View {
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 15) {
                DummySection(title: "Social Media")
                DummySection(title: "Social", isLong: true)
                ParallaxImageView(usesFullWidth: true) { size in
                    Image(.pic1)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: size.width, height: size.height)
                }
                .frame(height: 300)
                
                
                DummySection(title: "Buessniess", isLong: true)
                
                DummySection(title: "Promotion", isLong: true)
                
                ParallaxImageView(maximumMovement: 150, usesFullWidth: false) { size in
                    Image(.pic2)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: size.width, height: size.height)
                }
                .frame(height: 400)
                
                DummySection(title: "YouTube")
                DummySection(title: "Twitter (X)")
            }
        }
    }
    
    @ViewBuilder
    func DummySection(title: String, isLong: Bool = false) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.title.bold())
            Text("华科大工程学士、瑞士理工工程博士(微观-宏观计算机模型模拟)、美国Drexel大学博士后、计算机硕士、多年计算机模型模拟经验与教训、二十年硅谷互联网开发经验与教训、五年区块链开发经验与教训、All-in-AI。特约点评： 行业大模型：腾讯推出混元大模型直接在微信小程序可体验Chat版；百度推出行业大模型：数字政府“九州”，金融“开元”，工业“开物”，智能交通“ACE  AI的大型语言模型（LLM）部门SiloGen与芬兰图尔库大学的研究小组TurkuNLP联合启动一个开放和可信的LLM项目，以确保欧洲及欧洲语言的数字主权，并使所有人都能接触到LLM。\(isLong ? "大模型及工具：Meta的FACET推出公平计算机视觉评估以抵御可能生成的偏见；AI研究者证实AI反馈强化学习RLAIF与人力反馈强化学习RLHF直接PK双方不分胜负（大概像AlphaGo一样，下一次就可能是AI胜出了）；谷歌的AVIS能自动进行视觉信息搜索与多模态视觉-语言大模型PaLM-E 562B参数结合将可为机器人提供视觉感知及推理" : "")")
        }
    }
}

struct ParallaxImageView<Content: View>: View {
    var maximumMovement: CGFloat = 135.0
    var usesFullWidth: Bool = false
    @ViewBuilder var content: (CGSize) -> Content
    var body: some View {
        GeometryReader {
            let size = $0.size
            
            // movement Animation Properties
            let minY = $0.frame(in: .scrollView(axis: .vertical)).minY
            let scrollViewHeigtht = $0.bounds(of: .scrollView)?.size.height ?? 0
            let maximumMovement = min(maximumMovement, (size.height * 0.35))
            let stretchedSize: CGSize = .init(width: size.width, height: size.height + maximumMovement)
            
            let progress = minY / scrollViewHeigtht
            let cappedProgress = max(min(progress, 1.0), 0.0)
            let movementOffset = cappedProgress * -maximumMovement
            
            content(size)
                .offset(y: movementOffset)
                .frame(width: stretchedSize.width, height: stretchedSize.height)
                .frame(width: size.width, height: size.height)
                .clipped()
        }
        .containerRelativeFrame(usesFullWidth ? [.horizontal] : [])
    }
}

#Preview {
    ContentView()
}
