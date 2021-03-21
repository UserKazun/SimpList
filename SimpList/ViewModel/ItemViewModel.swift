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
    
    @Environment(\.timeZone) var timeZone
    
    static let logger = Logger(subsystem: "com.devKazu.SimpList", category: "Item")
    
    var cancellables: [AnyCancellable] = []
    
    init(_ inMemory: Bool) {
        self.itemModelStore = ItemModelStore(inMemory)
        items = itemModelStore.items
        
        cancellables.append(NotificationCenter.default
                                .publisher(for: Notification.Name.NSManagedObjectContextObjectsDidChange)
                                .sink { notification in
                                    self.updateItems(notification)
                                })
    }
    
    func updateItems(_ notification: Notification?) {
        ItemViewModel.logger.debug("updateItems called")
        self.items = itemModelStore.items
    }
    
    func createItem(_ title: String, _ detail: String = "") -> TodoItem {
        let newItem = itemModelStore.createItem(title, detail)
        items = itemModelStore.items
        
        return newItem
    }
    
    func deleteItem(_ item: TodoItem) {
        itemModelStore.removeItem(item)
    }
    
    func toggleIsDone(_ item: TodoItem) {
        self.itemModelStore.toggleIsDone(item)
    }
    
    func formattedDateForUserData(date: Date) -> String {
        let dateFormat = DateFormatter()
        dateFormat.dateStyle = .medium
        dateFormat.timeStyle = .medium
        dateFormat.dateFormat = "HH:mm"
        dateFormat.timeZone = timeZone
        let dateString = dateFormat.string(from: date)
        
        return dateString
    }
    
    func formattedDateForHeader() -> String {
        let dateFormat = DateFormatter()
        dateFormat.dateStyle = .medium
        dateFormat.timeStyle = .medium
        
        if TimeZone(identifier: "America/Halifax") == timeZone {
            dateFormat.dateFormat = "E MM-dd-yyyy"
        } else {
            dateFormat.dateFormat = "yyyy-MM-dd E"
        }
        dateFormat.timeZone = timeZone
        let dateString = dateFormat.string(from: Date())
        
        return dateString
    }
    
    static func previewViewModel() -> ItemViewModel {
        let viewModel = ItemViewModel(true)
        _ = viewModel.createItem("Item #1", "todo item detail")
        
        return viewModel
    }
}
