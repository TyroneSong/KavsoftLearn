//
//  Item+CoreDataProperties.swift
//  SPQuickResponseListData
//
//  Created by 宋璞 on 2023/7/31.
//

import CoreData
import Foundation

public extension Item {
    @nonobjc class func fetchRequest(ascending: Bool = true, batchSize: Int? = nil, returnObjectsAsFaults: Bool = false) -> NSFetchRequest<Item>{
        let fetchRequest = NSFetchRequest<Item>(entityName: "Item")
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Item.timestamp, ascending: ascending)]
        if let batchSize = batchSize {
            fetchRequest.fetchBatchSize = batchSize
        }
        fetchRequest.returnsObjectsAsFaults = returnObjectsAsFaults
        return fetchRequest
    }
    
    @NSManaged var timestamp: Date
    @NSManaged var section: Int16
}

extension Item: Identifiable {}
