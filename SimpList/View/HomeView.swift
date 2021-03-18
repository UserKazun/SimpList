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
            ScrollView {
                VStack(spacing: 15) {
                    ForEach(viewModel.items, id: \.self) { item in
                        VStack(alignment: .leading, spacing: 10) {
                            Text(item.title ?? "")
                            Text(item.detail ?? "")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(10)
                        .background(Color.gray.opacity(0.15))
                        .cornerRadius(10)
                        .contextMenu(menuItems: {
                            Button(action: {
                                deleteItems
                            }, label: {
                                Text("Delete")
                            })
                            
                            Button(action: {
//                                model.EditItem(item: item)
                            }, label: {
                                Text("Edit")
                            })
                        })
                    }
                }
                .padding()
            }
            .navigationTitle("RealmTodo")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: addItem, label: {
                        Image(systemName: "plus")
                            .font(.title)
                    })
                }
            }
            .sheet(isPresented: $showAddItemView) {
                AddItemView(showAddItemView: $showAddItemView)
            }
        }
    }
    
    private func addItem() {
        withAnimation {
            _ = viewModel.createItem("", "")
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
