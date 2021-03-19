//
//  ItemViewModel.swift
//  SimpList
//
//  Created by kazunari.ueeda on 2021/03/13.
//

import Foundation
import SwiftUI
import CoreData
import os
import Combine

class ItemViewModel: ObservableObject {
    var itemModelStore: ItemModelStore
    @Published var items: [TodoItem] = []
    @Published var showUndoneItems: Bool = true
    var predicate: NSPredicate {
        if showUndoneItems {
            return NSPredicate(format: "isDone == false")
        }
        return NSPredicate(format: "isDone == true")
    }
    
    static let logger = Logger(subsystem: "com.devKazu.SimpList", category: "Item")
    
    var cancellables: [AnyCancellable] = []
    
    init(_ inMemory: Bool) {
        self.itemModelStore = ItemModelStore(inMemory)
        items = itemModelStore.filtertedItems(predicate)
        
        cancellables.append(NotificationCenter.default
                                .publisher(for: Notification.Name.NSManagedObjectContextObjectsDidChange)
                                .sink { notification in
                                    self.updateItems(notification)
                                })
    }
    
    func updateItems(_ notification: Notification?) {
        ItemViewModel.logger.debug("updateItems called")
        self.items = itemModelStore.filtertedItems(predicate)
    }
    
    func createItem(_ title: String, _ detail: String = "") -> TodoItem {
        let newItem = itemModelStore.createItem(title, detail)
        items = itemModelStore.filtertedItems(predicate)
        
        return newItem
    }
    
    func deleteItem(_ item: TodoItem) {
        itemModelStore.removeItem(item)
    }
    
    func toggleIsDone(_ item: TodoItem) {
        self.itemModelStore.toggleIsDone(item)
    }
    
    func toggleDisplayFilter() {
        showUndoneItems.toggle()
        updateItems(nil)
    }
    
    static func previewViewModel() -> ItemViewModel {
        let viewModel = ItemViewModel(true)
        _ = viewModel.createItem("Item #1", "todo item detail")
        
        return viewModel
    }
}
