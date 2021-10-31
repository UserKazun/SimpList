//
//  AnalysisView.swift
//  SimpList
//
//  Created by kazunari_ueeda on 2021/10/23.
//

import SwiftUI

struct AnalysisView: View {
    var body: some View {
        ZStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        }
        .background(
            Image("Bg")
                .rotationEffect(.degrees(10))
                .offset(x: 460, y: -120)
                .accessibility(hidden: true)
        )
        .background(
            Image("Bg2")
                .offset(x: 190, y: 40)
                .accessibility(hidden: true)
        )
        .background(
            Image("Bg3")
                .rotationEffect(.degrees(-10))
                .offset(x: -250, y: -300)
        )
    }
}

struct AnalysisView_Previews: PreviewProvider {
    static var previews: some View {
        AnalysisView()
    }
}
