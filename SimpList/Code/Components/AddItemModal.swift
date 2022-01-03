//
//  AddItemModal.swift
//  SimpList
//
//  Created by kazunari_ueeda on 2021/10/31.
//

import SwiftUI

struct AddItemModal: View {
    @EnvironmentObject var viewModel: ItemViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State var title = ""
    @State var note = ""
    
    @State private var editItem: TodoItem
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                Text("Add a new Task!")
                    .font(.title).bold()
                    .padding()
                    .padding(.leading)
                
                form
            }
            .background(.ultraThinMaterial)
            .cornerRadius(30)
        }
    }
    
    var form: some View {
        Group {
            TextField("", text: $title)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .placeholder(when: title.isEmpty) {
                    Text("Title")
                        .foregroundColor(.primary)
                        .blendMode(.overlay)
                }
                .customField(icon: "pencil")
                .padding()
            
            TextField("", text: $note)
                .placeholder(when: note.isEmpty) {
                    Text("Note")
                        .foregroundColor(.primary)
                        .blendMode(.overlay)
                }
                .customField(icon: "")
                .padding()
            
            Button {
                _ = viewModel.createItem(
                    editItem.title,
                    editItem.note, "", "")
            } label: {
                AddTaskButton()
            }
        }
    }
}

//struct AddItemModal_Previews: PreviewProvider {
//    static var previews: some View {
//        AddItemModal(, editItem: <#TodoItem#>)
//    }
//}

struct AddTaskButton: View {
    var body: some View {
        VStack {
            Text("Add Task")
                .font(.headline)
            .foregroundStyle(.white)
        }
        .frame(width: UIScreen.main.bounds.width, height: 50)
        .background(Color("component"))
        .cornerRadius(15)
        .padding()
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
            ZStack(alignment: alignment) {
                placeholder().opacity(shouldShow ? 1 : 0)
                self
            }
        }
}

struct TextFieldModifier: ViewModifier {
    var icon: String
    
    func body(content: Content) -> some View {
        content
            .overlay(
                HStack {
                    Image(systemName: icon)
                        .frame(width: 36, height: 36)
                        .background(.thinMaterial)
                        .cornerRadius(14)
                        .offset(x: -46)
                        .foregroundStyle(.secondary)
                        .accessibility(hidden: true)
                    Spacer()
                }
            )
            .foregroundStyle(.primary)
            .padding(15)
            .padding(.leading, 40)
            .background(.thinMaterial)
            .cornerRadius(20)
    }
}

extension View {
    func customField(icon: String) -> some View {
        self.modifier(TextFieldModifier(icon: icon))
    }
}
