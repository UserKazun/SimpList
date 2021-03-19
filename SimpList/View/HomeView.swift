//
//  HomeView.swift
//  SimpList
//
//  Created by kazunari.ueeda on 2021/03/13.
//

import SwiftUI
import CoreData

struct HomeView: View {
    @EnvironmentObject var viewModel: ItemViewModel
    @State private var showAddItemView = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.items, id: \.self) { item in
                    TodoItemView(item: item)
                        .onTapGesture {
                            self.viewModel.toggleIsDone(item)
                        }
                }
                .onDelete(perform: deleteItems)
            }
            .navigationTitle("RealmTodo")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        
                    }, label: {
                        Text("Edit")
                    })
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        Button(action: {
                            viewModel.toggleDisplayFilter()
                        }, label: {
                            Image(systemName: viewModel.showUndoneItems ? "checkmark" : "circle")
                        })
                        
                        Button(action: {
                            showAddItemView.toggle()
                        }, label: {
                            Image(systemName: "plus")
                                .font(.title)
                        })
                    }
                    
                }
            }
            .sheet(isPresented: $showAddItemView) {
                AddItemView(showAddItemView: $showAddItemView)
            }
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { viewModel.items[$0] }.forEach(viewModel.deleteItem)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

struct TodoItemView: View {
    let item: TodoItem
    
    var body: some View {
        HStack {
            Image(systemName: item.isDone ? "checkmark" : "circle")
            
            VStack {
                Text(item.title)
                Text(item.detail)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
    }
}
