//
//  Expense.swift
//  CarScroll
//
//  Created by 宋璞 on 2023/11/9.
//

import SwiftUI


/// 费用
struct Expense: Identifiable {
    var id: UUID = UUID()
    var amountSpent: String
    var product: String
    var spendType: String
}


var expenses: [Expense] = [
    Expense(amountSpent: "$128", product: "Amazon Purchase", spendType: "Groceries"),
    Expense(amountSpent:"$10", product:"Youtube Premium", spendType: "Streaming"),
    Expense(amountSpent:"$10", product:"Dribbble",spendType: "Membership"),
    Expense(amountSpent:"$99", product: "Magic Keyboard", spendType: "products"),
    Expense(amountSpent:"$9", product: "Patreon", spendType: "Membership"),
    Expense(amountSpent:"$100",product: "Instagram", spendType: "Ad Publish"),
    Expense(amountSpent:"$15",product: "Netflix", spendType: "Streaming"),
    Expense(amountSpent:"$348",product: "photoshop", spendType: "Editing"),
    Expense(amountSpent:"$99",product: "Figma", spendType: "pro Member"),
    Expense(amountSpent:"$89",product: "Magic Mouse",spendType: "products"),
    Expense(amountSpent:"$1200", product: "studio Display", spendType: "products"),
    Expense(amountSpent:"$39", product: "Sketch Subscription", spendType: "Membership")
            ]



