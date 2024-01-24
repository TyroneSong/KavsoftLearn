//
//  Transaction.swift
//  ExpenseTracker
//
//  Created by 宋璞 on 2024/1/11.
//

import SwiftUI
import SwiftData

@Model
class Transaction {
    
    var title: String
    var remarks: String
    var amount: Double
    var dateAdded: Date
    var categroy: String
    var tintColor: String
    
    init(title: String, remarks: String, amount: Double, dateAdded: Date, categroy: Category, tintColor: TintColor) {
        self.title = title
        self.remarks = remarks
        self.amount = amount
        self.dateAdded = dateAdded
        self.categroy = categroy.rawValue
        self.tintColor = tintColor.color
    }
    
    /// Tells SwiftData not to persist the annotated property when managing the owning class.
    /// NOTE: By default, SwiftData does notpersist computed properties, Thus, it's notnecessary as it's a computedproperty, but l still used it.
    @Transient
    var color: Color {
        return tints.first(where: { $0.color == tintColor })?.value ?? appTint
    }
    
    @Transient
    var tint: TintColor? {
        return tints.first(where: { $0.color == tintColor })
    }
    
    @Transient
    var rawCategory: Category? {
        return Category.allCases.first(where: { $0.rawValue == categroy })
    }
}
