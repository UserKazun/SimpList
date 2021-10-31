//
//  TabITem.swift
//  SimpList
//
//  Created by kazunari_ueeda on 2021/10/23.
//

import SwiftUI

struct TabItem: Identifiable {
    let id = UUID()
    var name: String
    var icon: String
    var color: Color
    var selection: Tab
}

var TabItems = [
    TabItem(name: "Home", icon: "house", color: .purple, selection: .home),
    TabItem(name: "Analysis", icon: "magnifyingglass", color: .blue, selection: .analysis),
    TabItem(name: "Settings", icon: "gear", color: .pink, selection: .settings),
]

enum Tab: String {
    case home
    case analysis
    case settings
}
