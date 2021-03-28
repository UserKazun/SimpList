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
    
    func updateItem(_ item: TodoItem, _ title: String, _ startDate: String = "", _ endDate: String = "", _ note: String, _ isDone: Bool) -> TodoItem? {
        let updatedItem = itemModelStore.updateItem(item.id!, title: title, startDate: startDate, endDate: startDate, note: note, isDone: isDone)
        items = itemModelStore.items
        
        return updatedItem
    }
    
    func createItem(_ title: String, _ startDate: String = "", _ endDate: String = "", _ note: String) -> TodoItem {
        let newItem = itemModelStore.createItem(title, startDate, endDate, note)
        items = itemModelStore.items
        
        return newItem
    }
    
    func deleteItem(_ item: TodoItem) {
        itemModelStore.removeItem(item)
    }
    
    func toggleIsDone(_ item: TodoItem) {
        self.itemModelStore.toggleIsDone(item)
    }
    
    func formattedDateForUserData(inputDate: Date) -> String {
        let dateFormat = DateFormatter()
        dateFormat.dateStyle = .medium
        dateFormat.timeStyle = .medium
        dateFormat.dateFormat = "yyyy/M/d E HH:mm"
        dateFormat.timeZone = timeZone
        let dateString = dateFormat.string(from: inputDate)
        
        return dateString
    }
    
    func formattedDateForDisplayItem(inputDate: String) -> Date {
        let dateFormat = DateFormatter()
        dateFormat.dateStyle = .medium
        dateFormat.timeStyle = .medium
        dateFormat.dateFormat = "yyyy-MM-dd E"
        dateFormat.timeZone = timeZone
        let date = dateFormat.date(from: inputDate)
        
        return (date)!
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
        _ = viewModel.createItem("Item #1", "todo item start date", "todo item end date", "note")
        
        return viewModel
    }
}
