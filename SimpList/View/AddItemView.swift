//
//  AddItemView.swift
//  SimpList
//
//  Created by kazunari.ueeda on 2021/03/14.
//

import SwiftUI

struct AddItemView: View {
    @EnvironmentObject var model: ItemViewModel
    @Environment(\.managedObjectContext) var context
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .trailing, vertical: .bottom), content: {
            VStack {
                HStack {
                    Text("\(model.updateItem == nil ? "Add New" : "Update") Task")
                        .font(.system(size: 25))
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    
                    Spacer(minLength: 0)
                }
                .padding()
                
                List {
                    Section(header: Text("Title")) {
                        TextField("", text: $model.title)
                    }
                    
                    Section(header: Text("Detail")) {
                        TextField("", text: $model.detail)
                }
            }
            .padding(.vertical, 50)

            Button(action: {
                model.addData(context: context)
            }, label: {
                Image(systemName: "plus")
                    .font(.title2)
                    .padding(20)
                    .foregroundColor(.black)
            })
            .padding()
            
            .disabled(model.title == "" ? true: false)
            .opacity(model.title == "" ? 0.5 : 1)
            }
        }
    )}
}

struct AddItemView_Previews: PreviewProvider {
    static var previews: some View {
        AddItemView()
    }
}
