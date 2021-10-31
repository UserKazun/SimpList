//
//  Header.swift
//  SimpList
//
//  Created by kazunari_ueeda on 2021/10/24.
//

import SwiftUI

struct Header: View {
    let dateFormat = DateFormat()
    
    var body: some View {
        VStack {
            Text("TODAY")
                .sectionTitleModifier()
            
            VStack {
                Text("\(dateFormat.formattedDateForHeader())")
                    .font(Font.custom(FontsManager.Monstserrat.bold, size: 28))
                    .offset(x: -30, y: -40)
            }
            .frame(width: 330, height: 160)
            .background(.ultraThinMaterial)
            .cornerRadius(15)
            .overlay(
                Image("header")
                    .offset(y: 50)
            )
        }
    }
}

struct Header_Previews: PreviewProvider {
    static var previews: some View {
        Header()
    }
}
