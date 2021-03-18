//
//  ItemModel.swift
//  SimpList
//
//  Created by kazunari.ueeda on 2021/03/16.
//

import Foundation
import CoreData
import os

struct ItemModel {
    var id: UUID? = nil
    var title: String = ""
    var detail: String = ""
    let logger = Logger(subsystem: "com.devKazu.SimpList", category: "Item")
    
    init(_ title: String, _ detail: String = "") {
        self.id = UUID()
        self.title = title
        self.detail = detail
    }
}

struct ItemModelStore {
    let container: NSPersistentContainer
    let logger = Logger(subsystem: "com.devKazu.SimpList", category: "Item")
    let items: [ItemModel] = []
    
    init(_ inMemory: Bool) {
        container = NSPersistentContainer(name: "MyTodo")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
        
    func fetchFromCoreData() -> [ItemModel] {
        var items: [ItemModel] = []
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        do {
            items = try container.viewContext.fetch(request).map(ItemModel.init)
        } catch {
            logger.error("error in fetching data from coredata")
        }
        
        return items
    }
}

extension ItemModel {
    init(_ item: Item) {
        self.id = item.id
        self.title = item.title ?? ""
        self.detail = item.detail ?? ""
    }
}

extension ItemModelStore {
    func createItem(_ title: String, _ detail: String = "") -> ItemModel {
        let newItem = ItemModel(title, detail)
        let description = NSEntityDescription.entity(forEntityName: "Item", in: container.viewContext)!
        let newCoreDataItem = Item(entity: description, insertInto: container.viewContext)
        newCoreDataItem.id = newItem.id
        newCoreDataItem.title = newItem.title
        newCoreDataItem.detail = newItem.detail
        save()
        
        return newItem
    }
    
    func removeItem(_ item: ItemModel) {
        guard let id = item.id else { return }
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Item")
        request.predicate = NSPredicate.init(format: "id == %@", id as CVarArg)
        
        let deleteRequest = NSBatchDeleteRequest.init(fetchRequest: request)
        do {
            try self.container.viewContext.execute(deleteRequest)
        } catch {
            print(error)
        }
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
}
