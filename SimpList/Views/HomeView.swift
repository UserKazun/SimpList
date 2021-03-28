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
    
    @State var navigationBarHiddened: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack(alignment: Alignment(horizontal: .trailing, vertical: .bottom), content: {
                VStack {
                    Header()
                    
                    HStack {
                        Text("\(viewModel.items.count)")
                            .font(Font.custom(FontsManager.Monstserrat.medium, size: 18))
                            .foregroundColor(Color("component"))
                            .fontWeight(.semibold)
                        
                        Text("Tasks")
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
            .navigationBarHidden(navigationBarHiddened)
            .onAppear {
                navigationBarHiddened = true
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

struct Header: View {
    @EnvironmentObject var viewModel: ItemViewModel
    
    @State var isShow = false
    @State var viewState = CGSize.zero
    @State var isDragging = false
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                Text("SimpList")
                    .font(Font.custom(FontsManager.Monstserrat.bold, size: geometry.size.width / 10))
                    .foregroundColor(.white)
                    .offset(x: viewState.width / 15, y: viewState.height / 15)
                    .offset(x: 0, y: -70)
                
                Text("\(viewModel.formattedDateForHeader())")
                    .font(Font.custom(FontsManager.Monstserrat.bold, size: geometry.size.width / 10))
                    .foregroundColor(.white)
                    .offset(x: viewState.width / 15, y: viewState.height / 15)
                    .offset(x: 75, y: 50)
            }
            .frame(maxWidth: 300)
            .padding(.horizontal, 16)
        }
        .padding(.top, 100)
        .frame(height: 200)
        .frame(maxWidth: .infinity)
        .background(
            Image("top")
                .offset(x: viewState.width / 25, y: viewState.height / 25)
            , alignment: .center
        )
        .background(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.1294117647, green: 0.1450980392, blue: 0.4509803922, alpha: 1)), .purple]), startPoint: .topLeading, endPoint: .bottomTrailing))
        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
        .scaleEffect(isDragging ? 0.9 : 1)
        .animation(.timingCurve(0.2, 0.8, 0.2, 1, duration: 0.8))
        .rotation3DEffect(Angle(degrees: 5), axis: (x: viewState.width, y: viewState.height, z:0))
        .gesture(
            DragGesture().onChanged { value in
                self.viewState = value.translation
                self.isDragging = true
            }
            .onEnded { value in
                self.viewState = .zero
                self.isDragging = false
            }
        )
        .padding()
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
