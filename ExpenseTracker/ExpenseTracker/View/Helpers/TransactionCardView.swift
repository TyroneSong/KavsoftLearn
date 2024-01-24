//
//  TransactionCardView.swift
//  ExpenseTracker
//
//  Created by 宋璞 on 2024/1/11.
//

import SwiftUI

struct TransactionCardView: View {
    @Environment(\.modelContext) private var context
    var transaction: Transaction
    var showsCategory: Bool = false
    var body: some View {
        
        SwipeAction(cornerRadius: 10, direction: .trailing) {
            HStack(spacing: 12) {
                Text("\(String(transaction.title.prefix(1)))")
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .frame(width: 45, height: 45)
                    .background(transaction.color.gradient, in: .circle)
                
                VStack(alignment: .leading, spacing: 4, content: {
                    Text(transaction.title)
                        .foregroundStyle(Color.primary)
                    
                    Text(transaction.remarks)
                        .font(.caption)
                        .foregroundStyle(Color.primary.secondary)
                    
                    Text(formate(date: transaction.dateAdded ,formate: "dd MM yyyy"))
                        .font(.caption2)
                        .foregroundStyle(.gray)
                    
                    if showsCategory {
                        Text(transaction.categroy)
                            .font(.caption2)
                            .padding(.horizontal, 5)
                            .padding(.vertical, 2)
                            .foregroundStyle(.white)
                            .background(transaction.categroy == Category.income.rawValue ? Color.green.gradient : Color.red.gradient, in: .capsule)
                    }
                })
                .lineLimit(1)
                .hSpacing(.leading)
                
                Text(currencyString(transaction.amount ,allowedDigits:2))
                    .fontWeight(.semibold)
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 20)
            .background(.background, in: .rect(cornerRadius: 10))
        } actions: {
            Action(tint: .red, icon: "trash.fill") {
                context.delete(transaction)
            }
        }
    }
}

#Preview {
    ContentView()
}
