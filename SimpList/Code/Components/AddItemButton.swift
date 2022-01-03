//
//  AddItemButton.swift
//  SimpList
//
//  Created by kazunari_ueeda on 2021/12/29.
//

import SwiftUI

struct AddItemButton: View {
    @Binding var showAddItem: Bool
    
    var body: some View {
        Button(action: {
            showAddItem.toggle()
        }, label: {
            ZStack {
                Image(systemName: "plus")
                    .font(.headline)
                    .foregroundColor(.white)
                    .background(
                        Circle()
                            .frame(width: 50, height: 50)
                            .foregroundColor(Color("component"))
                            .shadow(color: .gray, radius: 15, x: 8, y: 0.5)
                    )
            }
        })
    }
}

struct AddItemButton_Previews: PreviewProvider {
    static var previews: some View {
        AddItemButton(showAddItem: .constant(false))
    }
}
