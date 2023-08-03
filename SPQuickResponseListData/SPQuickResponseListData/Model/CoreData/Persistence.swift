//
//  Persistence.swift
//  SPQuickResponseListData
//
//  Created by 宋璞 on 2023/7/31.
//

import CoreData
import os

final class PersistenceController {
    static let shared = PersistenceController()
    
    static let preView: PersistenceController = {
        PersistenceController()
    }()
    
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "FetchRequestDemo")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { _ , error in
            if let error = error as? NSError {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        try? container.viewContext.setQueryGenerationFrom(.current)
    }
    
    lazy var bgContext: NSManagedObjectContext = container.newBackgroundContext()
    
    var viewContext: NSManagedObjectContext {
        container.viewContext
    }
}

// MARK: - Extension
extension PersistenceController {
    private func context(type: ContextType) -> NSManagedObjectContext {
        switch type {
        case .main:
            return viewContext
        case .background:
            return bgContext
        }
    }
}

// MARK: - 增删改查
extension PersistenceController {
    /// 增
    func newItem(count: Int = 1, save: Bool = true, contextType: ContextType = .main) {
        let context = context(type: contextType)
        context.perform {
            for _ in 0..<count {
                let item = Item(context: context)
                item.timestamp = .now
                item.section = Int16.random(in: 0..<10)
            }
            if save {
                context.saveIfChange()
            }
        }
    }
    
    /// 删
    func delItem(_ item: Item) {
        guard let context = item.managedObjectContext else { return }
        context.perform {
            context.delete(item)
            context.saveIfChange()
        }
    }
    
    /// Count
    func itemCount(contextType: ContextType = .background) -> Int {
        let context = context(type: contextType)
        var count = 0
        context.performAndWait {
            count = (try? context.count(for: Item.fetchRequest()))!
        }
        return count
    }
    
    /// 清空
    func emptyItem() async {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Item")
        let emptyRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        emptyRequest.resultType = .resultTypeObjectIDs
        emptyRequest.affectedStores = bgContext.persistentStoreCoordinator?.persistentStores
        
        await bgContext.perform {
            do {
                let result = try self.bgContext.execute(emptyRequest)
                guard let result = result as? NSBatchDeleteResult, let ids = result.result as? [NSManagedObjectID] else { return }
                let changes = [NSDeletedObjectIDsKey: ids]
                NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [self.viewContext])
            } catch {
                Logger().error("Empty Item Error: \(error.localizedDescription)")
            }
        }
    }
    
    /// 批量插入 （40_000 条）
    func batchInsertItem(_ count: Int = 40000) async {
        var items: [[String: Any]] = []
        for _ in 0..<count {
            items.append(["timestamp": Date(), "section" : Int16.random(in: 0..<10)])
        }
        let request = batchInsertRequest(objects: items)
        request.resultType = .objectIDs
        await bgContext.perform {
            do {
                let result = try self.bgContext.execute(request)
                guard let result = result as? NSBatchInsertResult, let ids = result.result as? [NSManagedObjectID] else { return }
                let changes = [NSInsertedObjectIDsKey: ids]
                NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [self.viewContext])
            } catch {
                Logger().error("Batch Insert error: \(error.localizedDescription)")
            }
        }
    }
}

extension PersistenceController {
    /// 批量插入请求
    private func batchInsertRequest(entityName: String = "Item", objects: [[String: Any]]) -> NSBatchInsertRequest {
        let count = objects.count
        var index = 0
        return NSBatchInsertRequest(entityName: entityName) { dict in
            guard index < count else { return true }
            dict.addEntries(from: objects[index])
            index += 1
            return false
        }
    }
}

enum ContextType {
    case main, background
}

extension NSManagedObjectContext {
    func saveIfChange() {
        guard self.hasChanges else { return }
        do {
            try save()
        } catch {
            rollback()
            Logger().error("Save error: \(error.localizedDescription)")
        }
    }
}
