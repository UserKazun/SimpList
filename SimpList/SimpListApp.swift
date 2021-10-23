//
//  SimpListApp.swift
//  SimpList
//
//  Created by kazunari.ueeda on 2021/03/13.
//

import SwiftUI
import os

@main
struct SimpListApp: App {
    @StateObject var viewModel = ItemViewModel(true)
    
    static let logger = Logger(subsystem: "com.devKazu.SimpList", category: "SimpListApp")
    
    init() {
        let inMemory: Bool = ProcessInfo.processInfo.arguments.contains("TestWithInMemory")
        _viewModel = StateObject(wrappedValue: ItemViewModel(inMemory))
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
