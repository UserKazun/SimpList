//
//  ItemViewModel.swift
//  SimpList
//
//  Created by kazunari.ueeda on 2021/03/13.
//

import SwiftUI
import CoreData

class ItemViewModel: ObservableObject {
    @Published var title = ""
    @Published var detail = ""
    
    @Published var isNewData = false
    
    @Published var updateItem: Item!
    
    var count = 0
    
    func countItem(item: FetchedResults<Item>) -> Int {
        if !item.isEmpty {
            for _ in item {
                count += 1
            }
        }
        
        return count
    }
    
    func addData(context: NSManagedObjectContext) {
        if updateItem != nil {
            updateItem.title = title
            updateItem.detail = detail
            
            try! context.save()
            
            updateItem = nil
            isNewData.toggle()
            title = ""
            detail = ""
            
            return
        }
        
        let newItem = Item(context: context)
        newItem.title = title
        newItem.detail = detail
        
        do {
            try context.save()
            
            isNewData.toggle()
            title = ""
            detail = ""
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func EditItem(item: Item) {
        updateItem = item
        
        title = item.title!
        detail = item.detail!
    }
}
