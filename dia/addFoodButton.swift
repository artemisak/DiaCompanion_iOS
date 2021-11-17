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
    @State private var searchByWordCategoryView = false
    @State private var selectedFood: String = ""
    @State private var selectedFoodCategory: String = ""
    @State private var selectedFoodTemp = ""
    @State private var selectedFoodCategoryTemp = ""
    @State private var FFCT = FillFoodCategoryList()
    @Binding var foodItems: [String]
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
                                    selectedFoodTemp = i.name
                                    addScreen.toggle()
                                }){Text("\(i.name)")}.foregroundColor(.black)
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
                }.listStyle(.insetGrouped)
                if !addScreen {
                    addSreenView(addScreen: $addScreen, gramm: $gramm, selectedFood: $selectedFoodTemp, foodItems: $foodItems)
                }
            }
            .navigationTitle("Добавить блюдо")
        }
    }
    
    func GetFoodCategoryItemsView(category: String) -> some View {
        ZStack{
            List {
                Section {
                    TextField("Поиск по слову", text: $selectedFoodCategory)
                        .onChange(of: selectedFoodCategory, perform: {i in
                            if selectedFoodCategory == "" {
                                searchByWordCategoryView = false
                            } else {
                                searchByWordCategoryView = true
                            }
                        })
                }
                if searchByWordCategoryView{
                    let itemsArray = GetFoodCategoryItems(_category: category)
                    Section {
                        ForEach(itemsArray.filter{$0.name.contains(selectedFoodCategory)}, id:\.self){i in
                            Button(action: {
                                selectedFoodCategoryTemp = i.name
                                addScreen.toggle()
                            }){Text("\(i.name)")}
                        }
                    }
                }
                if !searchByWordCategoryView{
                Section {
                    ForEach(GetFoodCategoryItems(_category: category), id:\.self){i in
                        Button(action: {
                            selectedFoodCategoryTemp = i.name
                            addScreen.toggle()
                        }){Text("\(i.name)")}
                    }
                }
                }
            }
            if !addScreen {
                addSreenView(addScreen: $addScreen, gramm: $gramm, selectedFood: $selectedFoodCategoryTemp, foodItems: $foodItems)
            }
        }
        .listStyle(.plain)
        .navigationTitle(category)
        .navigationBarTitleDisplayMode(.inline)
        .interactiveDismissDisabled()
    }
}

//struct addFoodButton_Previews: PreviewProvider {
//    static var previews: some View {
//        addFoodButton()
//    }
//}
