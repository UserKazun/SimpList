//
//  ContentsView.swift
//  SimpList
//
//  Created by kazunari_ueeda on 2021/10/23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: ItemViewModel
    @AppStorage("selectedTab") var selectedTab: Tab = .home
    
    var body: some View {
        ZStack {
            Group {
                switch selectedTab {
                case .home:
                    HomeView()
                case .analysis:
                    AnalysisView()
                case .addItem:
                    AddItemView()
                case .settings:
                    SettingsView()
                }
            }
            .safeAreaInset(edge: .bottom) {
                VStack {}.frame(height: 44)
            }
            
            TabBar()
        }
        .dynamicTypeSize(.large ... .xxLarge)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ItemViewModel(true))
    }
}
