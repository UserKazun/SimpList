//
//  MoreView.swift
//  SimpList
//
//  Created by kazunari.ueeda on 2021/03/27.
//

import SwiftUI

struct MoreView: View {
    @EnvironmentObject var viewModel: ItemViewModel
    
    @State var itemTitle: String = ""
    @State var startDate: Date = Date()
    @State var endDate: Date = Date()
    @State var note: String = ""
    
    @State private var isShowMapView: Bool = false
    @State private var isShowNote: Bool = false
    
    @Binding var isShowMoreView: Bool
    
    var body: some View {
        ZStack {
//            MapView()
//                .opacity(isShowMapView ? 1 : 0)
            ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom), content: {
                ScrollView(.vertical, showsIndicators: false, content: {
                    VStack(alignment: .leading) {
                        HStack {
                            TextField("New Task ...", text: $itemTitle)
                                .font(Font.custom(FontsManager.Monstserrat.bold, size: 24))
                        }
                        .frame(height: 20)
                        .padding(.leading, 50)
                        .padding(.top, 60)
                        .padding(.bottom, 35)
                        .padding(.trailing, 10)
                        
                        HStack {
                            Image(systemName: "arrow.clockwise.circle")
                                .padding(.trailing, 15)
                            Text("Start")
                                .font(Font.custom(FontsManager.Monstserrat.regular, size: 17))
                                .padding(.trailing, 10)
                            DatePicker("", selection: $startDate)
                                .labelsHidden()
                        }
                        .padding(.leading, 50)
                        .padding(.bottom, 15)
                        
                        HStack {
                            Image(systemName: "arrow.counterclockwise.circle")
                                .padding(.trailing, 15)
                            Text("End")
                                .font(Font.custom(FontsManager.Monstserrat.regular, size: 17))
                                .padding(.trailing, 17)
                            DatePicker("", selection: $endDate)
                                .labelsHidden()
                        }
                        .padding(.leading, 50)
                        .padding(.bottom, 15)
                        
                        HStack {
                            Image(systemName: "location")
                                .padding(.trailing, 15)
                            
                            Text("Location")
                                .font(Font.custom(FontsManager.Monstserrat.regular, size: 17))
                        }
                        .padding(.leading, 50)
                        .padding(.bottom, 15)
                        .onTapGesture {
                            isShowMapView.toggle()
                        }
                        
                        HStack {
                            Image(systemName: "pencil")
                                .padding(.trailing, 15)
                            
                            Text("Note")
                                .font(Font.custom(FontsManager.Monstserrat.regular, size: 17))
                        }
                        .padding(.leading, 50)
                        .padding(.bottom, 15)
                        .onTapGesture {
                            withAnimation {
                                isShowNote.toggle()
                            }
                        }
                        
                        ZStack(alignment: Alignment(horizontal: .leading, vertical: .top), content: {
                            VStack {
                                TextEditor(text: $note)
                                    .font(.title2)
                                    .frame(width: UIScreen.main.bounds.width - 100, height: 250)
                                    .colorMultiply(Color(#colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)))
                                    .cornerRadius(15)
                            }
                            .padding(.leading, 50)
                            .padding(.bottom, 15)
                            
                            if self.note == "" {
                                Text("Write a note...")
                                    .padding()
                                    .padding(.leading, 50)
                                    .foregroundColor(Color.black.opacity(0.18))
                            }
                        })
                        .opacity(isShowNote ? 1 : 0)
                        
                    }
                })
                
                Button(action: {
                    let startDateString = viewModel.formattedDateForUserData(date: startDate)
                    let endDateString = viewModel.formattedDateForUserData(date: endDate)
                    
                    _ = viewModel.createItem(itemTitle, startDateString, endDateString, note)
                    
                    isShowMoreView.toggle()
                }, label: {
                    HStack {
                        Text("Add New Task")
                            .font(Font.custom(FontsManager.Monstserrat.bold, size: 18))
                    }
                    .padding()
                    .frame(width: UIScreen.main.bounds.width - 50, height: 60)
                    .background(itemTitle == "" ? Color.gray : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(15)
                })
                .padding(.bottom, 40)
                .disabled(itemTitle == "" ? true : false)
            })
            
        }
        .onTapGesture {
            hideKeyboard()
        }
//        .sheet(isPresented: $isShowMapView, content: {
//            MapView()
//                .environmentObject(mapData)
//        })
    //}
    }
}

struct MoreView_Previews: PreviewProvider {
    static var previews: some View {
        MoreView(isShowMoreView: .constant(true))
    }
}

struct SubTaskTextField: View {
    @Binding var subTask: String
    
    var body: some View {
        HStack {
            Image(systemName: "pencil")
                .foregroundColor(.blue)
                .padding(.trailing, 15)
            
            TextField("Write a subTask", text: $subTask)
                .font(Font.custom(FontsManager.Monstserrat.medium, size: 17))
        }
        .frame(height: 50)
        .padding(.leading, 50)
    }
}

struct SubItem: View {
    var systemName: String = ""
    var textTitle: String = ""
    
    @Binding var isShowMapView: Bool
    
    var body: some View {
        HStack {
            Image(systemName: systemName)
                .padding(.trailing, 15)
            
            Text(textTitle)
                .font(Font.custom(FontsManager.Monstserrat.regular, size: 17))
        }
        .padding(.leading, 50)
        .padding(.bottom, 15)
        .onTapGesture {
            isShowMapView.toggle()
        }
    }
}