//
//  HomeView.swift
//  SimpList
//
//  Created by kazunari.ueeda on 2021/03/13.
//

import SwiftUI
import CoreData

struct HomeView: View {
    @StateObject var model = ItemViewModel()
    
    @FetchRequest(entity: Item.entity(), sortDescriptors: [NSSortDescriptor(key: "title", ascending: true)], animation: .spring()) var results: FetchedResults<Item>
    @Environment(\.managedObjectContext) var context
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 15) {
                    ForEach(results) { item in
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
                                context.delete(item)
                                try! context.save()
                            }, label: {
                                Text("Delete")
                            })
                            
                            Button(action: {
                                model.EditItem(item: item)
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
                    Button(action: {
                        model.isNewData = true
                    }, label: {
                        Image(systemName: "plus")
                            .font(.title)
                    })
                }
            }
            .sheet(isPresented: $model.isNewData, content: {
                AddItemView().environmentObject(model)
            })
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
