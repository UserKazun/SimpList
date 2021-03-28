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
    
    @State private var itemTitle: String = ""
    @State private var date: Date = Date()
    
    @State private var isShowMoreView: Bool = false
    @State private var isTapItem: Bool = false
    @State var isFocused: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack(alignment: Alignment(horizontal: .trailing, vertical: .bottom), content: {
                VStack {
                    HStack {
                        Text("\(viewModel.items.count)")
                            .font(Font.custom(FontsManager.Monstserrat.medium, size: 18))
                            .foregroundColor(Color("component"))
                            .fontWeight(.semibold)
                        
                        Text("Tasks Today")
                            .font(Font.custom(FontsManager.Monstserrat.medium, size: 18))
                            .foregroundColor(Color("primary"))
                            .fontWeight(.semibold)
                        
                        Spacer()
                    }
                    .padding()
                    
                    ScrollView(.vertical, showsIndicators: false, content: {
                        ForEach(viewModel.items, id: \.self) { item in
                            HStack(spacing: 20) {
                                Button(action: {
                                    self.viewModel.toggleIsDone(item)
                                }, label: {
                                    if item.isDone {
                                        LottieView()
                                            .frame(width: 45, height: 45)
                                    } else {
                                        Image(systemName: "circle")
                                            .font(.title2)
                                            .frame(width: 45, height: 45)
                                    }
                                })
                                
                                NavigationLink(
                                    destination: MoreView(item),
                                    label: {
                                        VStack(alignment: .leading) {
                                            Text("\(item.title)")
                                                .font(Font.custom(FontsManager.Monstserrat.medium, size: 18))
                                                .fontWeight(.regular)
                                                .foregroundColor(Color("primary"))
                                                .multilineTextAlignment(.leading)
                                            
                                            Text("\(item.startDate)")
                                                .font(Font.custom(FontsManager.Monstserrat.medium, size: 14))
                                                .foregroundColor(Color.gray.opacity(0.8))
                                            
                                            if item.endDate != "" {
                                                Text(" ~ \(item.endDate)")
                                                    .font(Font.custom(FontsManager.Monstserrat.medium, size: 14))
                                                    .foregroundColor(Color.gray.opacity(0.8))
                                            }
                                        }
                                    })
                                    .contextMenu(menuItems: {
                                        Button(action: {
                                            withAnimation {
                                                viewModel.deleteItem(item)
                                            }
                                        }, label: {
                                            Text("Delete")
                                        })
                                    })
                                
                                Spacer()
                                
                                if item.note != "" {
                                    Image(systemName: "pencil")
                                        .foregroundColor(Color("primary"))
                                        .padding(.trailing, 10)
                                }
                            }
                            .padding(.leading)
                            .padding(.top, 5)
                        }
                    })
                }
                
                HStack {
                    TextField("Write a new task...", text: $itemTitle,
                              onCommit: {
                                if itemTitle != "" {
                                    let startDateString = viewModel.formattedDateForUserData(inputDate: date)
                                    let endDateString = ""
                                    let note = ""
                                    _ = viewModel.createItem(itemTitle, startDateString, endDateString, note)
                                }
                                
                                itemTitle = ""
                              })
                        .padding()
                        .onTapGesture {
                            isFocused.toggle()
                        }
                    
                    Button(action: {
                        isShowMoreView.toggle()
                    }, label: {
                        Text("more")
                            .font(Font.custom(FontsManager.Monstserrat.medium, size: 17))
                    })
                    .padding()
                }
                .frame(height: 50)
                .background(Color("secondary"))
                .cornerRadius(15)
                .padding()
                .padding(.top, 20)
                .animation(.spring())
            })
            .sheet(isPresented: $isShowMoreView, content: {
                MoreView(nil)
            })
            .background(Color("background").edgesIgnoringSafeArea(.all))
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

struct ItemCount: View {
    var count: Int
    
    var body: some View {
        HStack {
            Text("\(count)")
                .font(Font.custom(FontsManager.Monstserrat.medium, size: 18))
                .foregroundColor(Color(#colorLiteral(red: 0.368627451, green: 0.431372549, blue: 1, alpha: 1)))
                .fontWeight(.semibold)
            
            Text("Tasks Today")
                .font(Font.custom(FontsManager.Monstserrat.medium, size: 18))
                .foregroundColor(Color("primary"))
                .fontWeight(.semibold)
            
            Spacer()
        }
        .padding()
    }
}

struct ItemContent: View {
    var title: String
    var startDate: String
    var endDate: String
    
    var item: TodoItem
    
    @Binding var isShowMoreView: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(title)")
                .font(Font.custom(FontsManager.Monstserrat.medium, size: 18))
                .fontWeight(.regular)
                .multilineTextAlignment(.leading)
            
            Text("\(startDate)")
                .font(Font.custom(FontsManager.Monstserrat.medium, size: 14))
                .foregroundColor(Color.gray.opacity(0.8))
            
            if endDate != "" {
                Text(" ~ \(endDate)")
                    .font(Font.custom(FontsManager.Monstserrat.medium, size: 14))
                    .foregroundColor(Color.gray.opacity(0.8))
            }
        }
        .onTapGesture {
            isShowMoreView.toggle()
        }
    }
}

struct CustomTextField: View {
    @EnvironmentObject var viewModel: ItemViewModel
    @Binding var date: Date
    @Binding var itemTitle: String
    @Binding var isShowMoreView: Bool
    @Binding var isFocused: Bool
    
    var body: some View {
        HStack {
            TextField("Write a new task...", text: $itemTitle,
                      onCommit: {
                        if itemTitle != "" {
                            let startDateString = viewModel.formattedDateForUserData(inputDate: date)
                            let endDateString = ""
                            let note = ""
                            _ = viewModel.createItem(itemTitle, startDateString, endDateString, note)
                        }
                        
                        itemTitle = ""
                      })
                .padding()
                .onTapGesture {
                    isFocused.toggle()
                }
            
            Button(action: {
                isShowMoreView.toggle()
            }, label: {
                Text("more")
                    .font(Font.custom(FontsManager.Monstserrat.medium, size: 17))
            })
            .padding()
        }
        .frame(height: 50)
        .background(Color("secondary"))
        .cornerRadius(15)
        .padding()
        .padding(.top, 20)
        .animation(.spring())
    }
}

func hideKeyboard() {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
}
