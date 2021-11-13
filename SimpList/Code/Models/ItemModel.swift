//
//  ItemModel.swift
//  SimpList
//
//  Created by kazunari.ueeda on 2021/03/16.
//

import Foundation
import CoreData
import os

struct TodoItem: Identifiable, Hashable {
    static let logger = Logger(subsystem: "com.devKazu.SimpList", category: "TodoItem")
    
    var id: UUID? = nil
    var title: String = ""
    var startDate: String = ""
    var endDate: String = ""
    var note: String = ""
    var isDone: Bool = false
    
    init(_ title: String, _ startDate: String = "", _ endDate: String = "", _ note: String, _ isDone: Bool = false) {
        self.id = UUID()
        self.title = title
        self.startDate = startDate
        self.endDate = endDate
        self.note = note
        self.isDone = isDone
    }
}

struct ItemModelStore {
    let container: NSPersistentContainer
    static let logger = Logger(subsystem: "com.devKazu.SimpList", category: "ItemModelStore")
    
    init(_ inMemory: Bool) {
        container = NSPersistentContainer(name: "SimpList")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
    
    var items: [TodoItem] {
        var items: [TodoItem] = []
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        do {
            items = try container.viewContext.fetch(request).map(TodoItem.init)
        } catch {
            ItemModelStore.logger.error("error in fetching data from coredata")
        }
        
        return items
    }
}

// MARK: CoreData dependent
extension TodoItem {
    init(_ item: Item) {
        self.id = item.id
        self.title = item.title ?? ""
        self.startDate = item.startDate ?? ""
        self.endDate = item.endDate ?? ""
        self.note = item.note ?? ""
        self.isDone = item.isDone
    }
}

extension ItemModelStore {
    @discardableResult
    func createItem(_ title: String, _ startDate: String = "", _ endDate: String = "", _ note: String, _ isDone: Bool = false) -> TodoItem {
        let newItem = TodoItem(title, startDate, endDate, note)
        let description = NSEntityDescription.entity(forEntityName: "Item", in: container.viewContext)!
        let newCoreDataItem = Item(entity: description, insertInto: container.viewContext)
        newCoreDataItem.id = newItem.id
        newCoreDataItem.title = newItem.title
        newCoreDataItem.startDate = newItem.startDate
        newCoreDataItem.endDate = newItem.endDate
        newCoreDataItem.note = newItem.note
        newCoreDataItem.isDone = newItem.isDone
        save()
        
        return newItem
    }
    
    func removeItem(_ item: TodoItem) {
        guard let id = item.id else { return }
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Item")
        request.predicate = NSPredicate.init(format: "id == %@", id as CVarArg)
        
        guard let items = try? container.viewContext.fetch(request),
              let coreDataItem = items.first as? Item, items.count == 1 else { return }
        
        container.viewContext.delete(coreDataItem)
        save()
    }
    
    func updateItem(
        _ id: UUID,
        title: String? = nil,
        startDate: String? = nil,
        endDate: String? = nil,
        note: String? = nil,
        isDone: Bool? = nil
    ) -> TodoItem? {
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Item")
        request.predicate = NSPredicate.init(format: "id == %@", id as CVarArg)
        
        guard let items = try? container.viewContext.fetch(request),
              items.count == 1, let coreDataItem = items.first as? Item else { return nil }
        if let title = title {
            coreDataItem.title = title
        }
        if let startDate = startDate {
            coreDataItem.startDate = startDate
        }
        if let endDate = endDate {
            coreDataItem.endDate = endDate
        }
        if let note = note {
            coreDataItem.note = note
        }
        save()
        
        return refetchItem(id)
    }
    
    func toggleIsDone(_ item: TodoItem) {
        guard let id = item.id else { return }
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Item")
        request.predicate = NSPredicate.init(format: "id == %@", id as CVarArg)
        
        guard let items = try? container.viewContext.fetch(request),
              let coreDataItem = items.first as? Item, items.count == 1 else { return }
        
        coreDataItem.isDone = !coreDataItem.isDone
        save()
    }
    
    func save() {
        if !container.viewContext.hasChanges { return }
        do {
            try container.viewContext.save()
        } catch {
            print(error)
        }
    }
    
    func refetchItem(_ id: UUID) -> TodoItem? {
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Item")
        request.predicate = NSPredicate.init(format: "id == %@", id as CVarArg)
        guard let items = try? container.viewContext.fetch(request),
              items.count == 1, let coreDataItem = items.first as? Item else { return nil }
        
        return TodoItem(coreDataItem)
    }
}
