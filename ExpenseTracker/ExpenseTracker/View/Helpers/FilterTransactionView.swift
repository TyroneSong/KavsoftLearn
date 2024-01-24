//
//  FilterTransactionView.swift
//  ExpenseTracker
//
//  Created by 宋璞 on 2024/1/23.
//

import SwiftUI
import SwiftData

/// Custom View
struct FilterTransactionView<Content: View>: View {
    var content: ([Transaction]) -> Content
    @Query(animation: .snappy) private var transactions: [Transaction]
    
    init(cattegory: Category?, searchText: String, @ViewBuilder content: @escaping ([Transaction]) -> Content) {
        // Custom Predicate
        let rawValue = cattegory?.rawValue ?? ""
        let predicate = #Predicate<Transaction> { transaction in
            return (transaction.title.localizedStandardContains(searchText) || transaction.remarks.localizedStandardContains(searchText)) && (rawValue.isEmpty ? true : transaction.categroy == rawValue)
        }
        
        _transactions = Query(filter: predicate, sort: [
            SortDescriptor(\Transaction.dateAdded, order: .reverse)
        ], animation: .snappy)
        
        self.content = content
        
    }
    
    init(startDate: Date, endDate: Date, @ViewBuilder content: @escaping ([Transaction]) -> Content) {
        // Custom Predicate
        
        let predicate = #Predicate<Transaction> { transaction in
            return transaction.dateAdded >= startDate && transaction.dateAdded <= endDate
        }
        
        _transactions = Query(filter: predicate, sort: [
            SortDescriptor(\Transaction.dateAdded, order: .reverse)
        ], animation: .snappy)
        
        self.content = content
        
    }
    
    var body: some View {
        content(transactions)
    }
}

