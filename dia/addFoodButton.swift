//
//  addFoodButton.swift
//  dia
//
//  Created by Артем  on 05.11.2021.
//

import SwiftUI

struct addFoodButton: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State public var gramm: String = ""
    @State public var addScreen: Bool = true
    @State private var searchByWordView = false
    @State public var selectedFood: String = ""
    @State private var FFCT = FillFoodCategoryList()
    
    var body: some View {
        NavigationView {
            ZStack{
                List {
                    Section(header: Text("Поиск по слову")){
                        TextField("Введние название блюда", text: $selectedFood)
                            .onChange(of: selectedFood, perform: {i in
                                if selectedFood == "" {
                                    searchByWordView = false
                                } else {
                                    searchByWordView = true
                                }
                            })
                    }
                    
                    if searchByWordView {
                        Section(header: Text("Поиск по слову")){
                            ForEach(GetFoodCategoryItemsByName(_name: selectedFood), id:\.self){i in
                                Button(action: {
                                    selectedFood = i.name
                                    addScreen.toggle()
                                }){Text("\(i.name)")}
                            }
                        }
                    }
                    
                    if !searchByWordView {
                        Section(header: Text("Поиск по категории")){
                            ForEach(FFCT, id:\.self){i in
                                NavigationLink(destination: GetFoodCategoryItemsView(category: "\(i.name)")) {
                                    Text("\(i.name)")
                                }.foregroundColor(.black)
                            }
                        }
                    }
                }
                if !addScreen {
                    addSreenView(addScreen: $addScreen, gramm: $gramm, selectedFood: $selectedFood)
                }
            }
            .navigationTitle("Добавить блюдо")
        }
    }
    
    func GetFoodCategoryItemsView(category: String) -> some View {
        ZStack{
            List {
                Section {
                    ForEach(GetFoodCategoryItems(_category: category), id:\.self){i in
                        Button(action: {
                            selectedFood = i.name
                            addScreen.toggle()
                        }){Text("\(i.name)")}
                    }
                }
            }
            if !addScreen {
                addSreenView(addScreen: $addScreen, gramm: $gramm, selectedFood: $selectedFood)
            }
        }
        .listStyle(.plain)
        .navigationTitle(category)
        .navigationBarTitleDisplayMode(.inline)
        .interactiveDismissDisabled()
    }
}


struct addFoodButton_Previews: PreviewProvider {
    static var previews: some View {
        addFoodButton()
    }
}
