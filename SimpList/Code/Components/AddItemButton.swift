//
//  AddItemButton.swift
//  SimpList
//
//  Created by kazunari_ueeda on 2021/12/29.
//

import SwiftUI

struct AddItemButton: View {
    var body: some View {
        Button(action: {
            
        }, label: {
            ZStack {
                Image(systemName: "plus")
                    .font(.headline)
                    .foregroundColor(.black)
                    .background(
                        Circle()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.blue)
                            .shadow(color: .gray, radius: 15, x: 8, y: 0.5)
                    )
            }
        })
    }
}

struct AddItemButton_Previews: PreviewProvider {
    static var previews: some View {
        AddItemButton()
    }
}
