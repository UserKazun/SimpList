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
    @Published var itemModelStore: ItemModelStore
    
    let logger = Logger(subsystem: "com.devKazu.SimpList", category: "Item")
    
    init() {
        self.itemModelStore = ItemModelStore(false)
    }
}
