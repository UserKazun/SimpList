//
//  TextModifiers.swift
//  SimpList
//
//  Created by kazunari_ueeda on 2021/10/24.
//

import SwiftUI

struct SectionTitleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.footnote.weight(.semibold))
            .foregroundColor(.secondary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding([.leading, .top], 30)
    }
}

extension View {
    func sectionTitleModifier() -> some View {
        modifier(SectionTitleModifier())
    }
}
