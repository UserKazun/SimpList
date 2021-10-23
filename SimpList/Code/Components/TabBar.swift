//
//  TabBar.swift
//  SimpList
//
//  Created by kazunari_ueeda on 2021/10/23.
//

import SwiftUI

struct TabBar: View {
    @State var color: Color = .blue
    @State var selectedX: CGFloat = 0
    @State var x: [CGFloat] = [0, 0, 0, 0]
    
    @AppStorage("selectedTab") var selectedTab: Tab = .home
    
    var body: some View {
        HStack {
            content
        }
        .padding(.bottom, 0)
        .frame(maxWidth: .infinity, maxHeight: 88)
        .background(.ultraThinMaterial)
        .background(
            Circle()
                .fill(color)
                .offset(x: selectedX, y: -10)
                .frame(width: 88)
                .frame(maxWidth: .infinity, alignment: .leading)
        )
        .cornerRadius(15)
        .frame(maxHeight: .infinity, alignment: .bottom)
        .ignoresSafeArea()
    }
    
    var content: some View {
        ForEach(Array(TabItems.enumerated()), id: \.offset) { index, tab in
            if index == 0 { Spacer() }
            
            Button {
                selectedTab = tab.selection
                withAnimation(.spring()) {
                    selectedX = x[index]
                    color = tab.color
                }
            } label: {
                VStack {
                    Image(systemName: tab.icon)
                        .symbolVariant(.fill)
                        .font(.system(size: 17, weight: .bold))
                        .frame(width: 44, height: 29)
                    Text(tab.name).font(.caption2)
                        .frame(width: 88)
                        .lineLimit(1)
                }
                .overlay(
                    GeometryReader { proxy in
                        let offset = proxy.frame(in: .global).minX
                        Color.clear
                            .preference(key: TabPreferenceKey.self, value: offset)
                            .onPreferenceChange(TabPreferenceKey.self) { value in
                                x[index] = value
                                if selectedTab == tab.selection {
                                    selectedX = x[index]
                                }
                            }
                    }
                )
            }
            .frame(width: 44)
            .foregroundColor(selectedTab == tab.selection ? .primary : .secondary)
            .blendMode(selectedTab == tab.selection ? .overlay : .normal)
            
            Spacer()
        }
    }
}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBar()
    }
}

struct TabPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
