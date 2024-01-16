//
//  CardView.swift
//  ExpenseTracker
//
//  Created by 宋璞 on 2024/1/11.
//

import SwiftUI

struct CardView: View {
    var income: Double
    var expense: Double
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(.background)
            
            VStack(spacing: 0) {
                HStack (spacing: 12) {
                    Text("\(currencyString(income - expense))")
                        .font(.title.bold())
                    
                    Image(systemName: expense > income ? "chart.line.downtrend.xyaxis" : "chart.line.uptrend.xyaxis")
                        .font(.title3)
                        .foregroundStyle(expense > income ? .red : .green)
                }
                .padding(.bottom, 25)
                
                HStack(spacing: 0) {
                    ForEach(Category.allCases, id: \.rawValue) { category in
                        let symbolImage = category == .income ? "arrow.down" : "arrow.up"
                        let tint: Color = category == .income ? .green : .red
                        
                        HStack(spacing: 10) {
                            Image(systemName: symbolImage)
                                .font(.callout.bold())
                                .foregroundStyle(tint)
                                .frame(width: 35, height: 35)
                                .background {
                                    Circle()
                                        .fill(tint.opacity(0.25).gradient)
                                }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(category.rawValue)
                                    .font(.caption2)
                                    .foregroundStyle(.gray)
                                
                                Text(currencyString( category == .income ? income : expense, allowedDigits:0))
                                    .font(.callout)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.primary)
                            }
                            
                            if category == .income {
                                Spacer(minLength: 10)
                            }
                        }
                    }
                }
            }
            .padding([.horizontal, .bottom], 25)
            .padding(.top, 15)
        }
    }
}

#Preview {
    ScrollView {
        CardView(income: 4598, expense: 2348)
    }
}
