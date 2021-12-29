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
    
    let dateFormat = DateFormat()
    
    @State private var itemTitle: String = ""
    @State private var date: Date = Date()
    
    @State private var isShowMoreView: Bool = false
    @State private var isTapItem: Bool = false
    @State var isFocused: Bool = false
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .trailing, vertical: .bottom), content: {
            VStack {
                Header()
                
                ScrollView(.vertical, showsIndicators: false, content: {
                    ForEach(viewModel.items, id: \.self) { item in
                        HStack(spacing: 20) {
                            Button(action: {
                                self.viewModel.toggleIsDone(item)
                            }, label: {
                                if item.isDone {
                                    Image("check")
                                        .frame(width: 45, height: 45)
                                } else {
                                    Image(systemName: "circle")
                                        .font(.title2)
                                        .frame(width: 45, height: 45)
                                }
                            })
                        }
                        .padding(.top, 15)
                        .padding(.bottom, 14)
                        .padding(.leading)
                        .padding(.trailing, 60)
                    }
                    .padding(.top)
                })
                
                AddItemButton()
                    .frame(maxWidth: .infinity, alignment: .bottomTrailing)
                    .padding(30)
            }
        })
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

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(ItemViewModel(true))
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

func hideKeyboard() {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
}
