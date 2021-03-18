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
    @Published var items: [ItemModel] = []
    
    let logger = Logger(subsystem: "com.devKazu.SimpList", category: "Item")
    
    init(_ inMemory: Bool) {
        self.itemModelStore = ItemModelStore(inMemory)
        items = itemModelStore.items
    }
    
    func createItem(_ title: String, _ detail: String = "") -> ItemModel {
        let newItem = itemModelStore.createItem(title, detail)
        items = itemModelStore.items
        
        return newItem
    }
    
    func deleteItem(_ item: ItemModel) {
        itemModelStore.removeItem(item)
        items = itemModelStore.items
    }
}
