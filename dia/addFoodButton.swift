//
//  addFoodButton.swift
//  dia
//
//  Created by Артем  on 05.11.2021.
//

import SwiftUI

struct addFoodButton: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State public var addScreen: Bool = true
    @State private var searchByWordView: Bool = true
    @State private var searchByWordCategoryView: Bool = true
    @State public var gram: String = ""
    @State private var selectedFood: String = ""
    @State private var selectedFoodCategoryItem: String = ""
    @State private var selectedFoodTemp: String = ""
    @State private var selectedFoodCategoryTemp: String = ""
    @State private var FoodCList: [FoodCategory] = []
    @State private var FoodList: [FoodItemByName] = []
    @Binding var foodItems: [String]
    
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    Section {
                        if !searchByWordView {
                            ForEach(FoodList, id: \.id){i in
                                Button(action: {
                                    selectedFoodTemp = i.name
                                    addScreen.toggle()
                                }){Text("\(i.name)")}.foregroundColor(.black)
                            }
                        } else {
                            ForEach(FoodCList, id: \.id){i in
                                NavigationLink(destination: GetFoodCategoryItemsView(category: "\(i.name)")) {
                                    Text("\(i.name)")
                                }.foregroundColor(.black)
                            }
                        }
                    }
                }
                .task {
                    FoodCList = await FillFoodCategoryList()
                }
                .listStyle(.plain)
                if !addScreen {
                    addSreenView(addScreen: $addScreen, gram: $gram, selectedFood: $selectedFoodTemp, foodItems: $foodItems)
                }
            }
            .navigationTitle("Добавить блюдо")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Закрыть")
                }
            }
            .interactiveDismissDisabled()
        }
        .searchable(
            text: $selectedFood,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt:  "Поиск по слову"
        )
        .onChange(of: selectedFood, perform: {i in
            if i.isEmpty {
                searchByWordView = true
            } else {
                Task {
                    FoodList = try await GetFoodItemsByName(_name: selectedFood)
                    searchByWordView = false
                }
            }
        })
    }
    
    @ViewBuilder
    func GetFoodCategoryItemsView(category: String) -> some View {
        ZStack {
            List {
                Section {
                    ForEach(searchByWordCategoryView ? GetFoodCategoryItems(_category: category):GetFoodCategoryItems(_category: category).filter{$0.name.contains(selectedFoodCategoryItem)}){i in
                        Button(action: {
                            selectedFoodCategoryTemp = i.name
                            addScreen.toggle()
                        }){Text("\(i.name)")}
                    }
                }
            }
            if !addScreen {
                addSreenView(addScreen: $addScreen, gram: $gram, selectedFood: $selectedFoodCategoryTemp, foodItems: $foodItems)
            }
        }
        .searchable(
            text: $selectedFoodCategoryItem,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: "Поиск по слову"
        )
        .onChange(of: selectedFoodCategoryItem, perform: {i in
            searchByWordCategoryView = i.isEmpty ? true : false
        })
        .listStyle(.plain)
        .navigationTitle(category)
        .navigationBarTitleDisplayMode(.inline)
        .interactiveDismissDisabled()
    }
}

struct addFoodButton_Previews: PreviewProvider {
    static var previews: some View {
        addFoodButton(foodItems: .constant([]))
    }
}

