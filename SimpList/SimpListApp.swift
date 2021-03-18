//
//  SimpListApp.swift
//  SimpList
//
//  Created by kazunari.ueeda on 2021/03/13.
//

import SwiftUI

@main
struct SimpListApp: App {
    @StateObject var viewModel: ItemViewModel = ItemViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
